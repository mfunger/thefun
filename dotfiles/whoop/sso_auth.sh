if ! command -v aws &>/dev/null; then
    echo "[$(date)] AWS CLI not found. Please install it before proceeding. See docs here: https://whoopinc.atlassian.net/wiki/spaces/AI/pages/4333044096/CodeArtifact+Setup"
    exit 1
fi
if [ ! -f $HOME/.aws/config ]; then
	echo "Existing AWS config file not present. Creating SSO session and codeartifact profile..."
	mkdir -p $HOME/.aws
	printf '[sso-session okta]\nsso_start_url = https://d-926746a760.awsapps.com/start#/\nsso_region = us-west-2\nsso_registration_scopes = sso:account:access\n' >> $HOME/.aws/config
	aws configure set profile.codeartifact.sso_session okta
	aws configure set profile.codeartifact.sso_account_id 688238828846
	aws configure set profile.codeartifact.sso_role_name CodeArtifactAccess
	aws configure set profile.codeartifact.region us-west-2
	aws configure set profile.codeartifact.output json
	echo "AWS config, SSO session and codeartifact profile created successfully."
else
	echo "AWS config file exists. Checking SSO session and profile..."
	if ! grep -q "\[sso-session okta\]" $HOME/.aws/config; then
		echo "Adding sso-session okta to AWS config..."
		printf '\n[sso-session okta]\nsso_start_url = https://d-926746a760.awsapps.com/start#/\nsso_region = us-west-2\nsso_registration_scopes = sso:account:access\n' >> $HOME/.aws/config
		echo "sso-session okta added to AWS config."
	fi
	if ! grep -q "\[profile codeartifact\]" $HOME/.aws/config; then
		echo "Creating profile codeartifact..."
		aws configure set profile.codeartifact.sso_session okta
		aws configure set profile.codeartifact.sso_account_id 688238828846
		aws configure set profile.codeartifact.sso_role_name CodeArtifactAccess
		aws configure set profile.codeartifact.region us-west-2
		aws configure set profile.codeartifact.output json
		echo "Profile codeartifact created successfully."
	else
		echo "Profile codeartifact already exists. Skipping profile creation..."
	fi
fi

echo "Removing existing CodeArtifact crontab if any..."
CRON_JOB="$HOME/.aws/codeartifact_auth.sh"
(crontab -l | grep -v "$CRON_JOB" | grep -v '^SHELL=' | grep -v '^MAILTO=') | crontab -

echo "Backing up existing configuration files..."
if [ -f "$HOME/.npmrc" ]; then
    if [ -f "$HOME/.npmrc.bak" ]; then
        echo "Backup for .npmrc already exists, skipping..."
    else
        cp "$HOME/.npmrc" "$HOME/.npmrc.bak"
        echo "Backed up .npmrc to $HOME/.npmrc.bak"
    fi
else
    echo ".npmrc not found, skipping backup..."
fi
if [ -f "$HOME/.config/pip/pip.conf" ]; then
    if [ -f "$HOME/.config/pip/pip.conf.bak" ]; then
        echo "Backup for pip.conf already exists, skipping..."
    else
        cp "$HOME/.config/pip/pip.conf" "$HOME/.config/pip/pip.conf.bak"
        echo "Backed up pip.conf to $HOME/.config/pip/pip.conf.bak"
    fi
else
    echo "pip.conf not found, skipping backup..."
fi
mkdir -p $HOME/.m2
if [ -f "$HOME/.m2/settings.xml" ]; then
    if [ -f "$HOME/.m2/settings.xml.bak" ]; then
        echo "Backup for settings.xml already exists, skipping..."
    else
        cp "$HOME/.m2/settings.xml" "$HOME/.m2/settings.xml.bak"
        echo "Backed up settings.xml to $HOME/.m2/settings.xml.bak"
    fi
else
    echo "m2 settings.xml not found, skipping backup..."
fi
printf '%s\n' '<?xml version="1.0" encoding="UTF-8"?>' \
'<settings xmlns="http://maven.apache.org/SETTINGS/1.1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' \
'          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd">' \
'    <servers>' \
'        <server>' \
'            <id>codeartifact-snapshots</id>' \
'            <username>aws</username>' \
'            <password>placeholder</password>' \
'        </server>' \
'        <server>' \
'            <id>codeartifact-releases</id>' \
'            <username>aws</username>' \
'            <password>placeholder</password>' \
'        </server>' \
'    </servers>' \
'    <profiles>' \
'        <profile>' \
'            <id>codeartifact-snapshots</id>' \
'            <repositories>' \
'                <repository>' \
'                    <id>codeartifact-snapshots</id>' \
'                    <url>https://whoop-688238828846.d.codeartifact.us-west-2.amazonaws.com/maven/whoop-maven-snapshots/</url>' \
'                    <layout>default</layout>' \
'                    <releases>' \
'                        <enabled>true</enabled>' \
'                    </releases>' \
'                </repository>' \
'            </repositories>' \
'        </profile>' \
'        <profile>' \
'            <id>codeartifact-releases</id>' \
'            <repositories>' \
'                <repository>' \
'                    <id>codeartifact-releases</id>' \
'                    <url>https://whoop-688238828846.d.codeartifact.us-west-2.amazonaws.com/maven/whoop-maven-releases/</url>' \
'                    <layout>default</layout>' \
'                    <releases>' \
'                        <enabled>true</enabled>' \
'                    </releases>' \
'                </repository>' \
'            </repositories>' \
'        </profile>' \
'    </profiles>' \
'    <activeProfiles>' \
'       <activeProfile>codeartifact-snapshots</activeProfile>' \
'       <activeProfile>codeartifact-releases</activeProfile>' \
'    </activeProfiles>' \
'</settings>' > $HOME/.m2/settings.xml
rm -f $HOME/.aws/codeartifact_auth.log
rm -f $HOME/.aws/last_codeartifact_auth_run
SHELL_NAME=$(basename "$SHELL")
echo "#\!/usr/bin/env $SHELL_NAME" > $HOME/.aws/codeartifact_auth.sh
echo "export PATH=\"$PATH\"" >> $HOME/.aws/codeartifact_auth.sh;
cat >> $HOME/.aws/codeartifact_auth.sh <<'EOL'
set -e
LOG_FILE="$HOME/.aws/codeartifact_auth.log"
LAST_RUN_FILE="$HOME/.aws/last_codeartifact_auth_run"
AWS_PROFILE="codeartifact"
if [ -f "$LAST_RUN_FILE" ]; then
    LAST_RUN=$(cat "$LAST_RUN_FILE")
else
    LAST_RUN=0
fi
[[ "$LAST_RUN" =~ ^[0-9]+$ ]] || LAST_RUN=0
NOW=$(date +%s)
DIFF=$(( (NOW - LAST_RUN) / 3600 ))
if [ "$DIFF" -lt 12 ]; then
    echo "[$(date)] Less than 12 hours since last run, auth still valid. Skipping rest of run..." | tee -a $LOG_FILE
    exit 0
else
    rm -f $LOG_FILE
fi
if ! command -v aws &>/dev/null; then
    echo "[$(date)] AWS CLI not found. Please install it before proceeding. See docs here: https://whoopinc.atlassian.net/wiki/spaces/AI/pages/4333044096/CodeArtifact+Setup" | tee -a $LOG_FILE
    exit 1
fi
CLI_VERSION=$($(command -v aws) --version 2>&1 | sed -n 's/aws-cli\/\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/p')
REQUIRED_VERSION="2.22.0"
if [[ "$(printf '%s\n' "$REQUIRED_VERSION" "$CLI_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]]; then
    echo "[$(date)] AWS CLI version $CLI_VERSION is below the required version $REQUIRED_VERSION. Please update your AWS CLI. See https://whoopinc.atlassian.net/wiki/spaces/AI/pages/4333044096/CodeArtifact+Setup#%5BIMPORTANT%5D-Upgrade-AWS-CLI-to-the-latest-version-if-you-already-have-it-installed" | tee -a $LOG_FILE
    exit 1
fi
if ! aws configure list-profiles | grep -q "^$AWS_PROFILE$"; then
    echo "[$(date)] AWS profile '$AWS_PROFILE' not configured. See docs here: https://whoopinc.atlassian.net/wiki/spaces/AI/pages/4333044096/CodeArtifact+Setup" | tee -a $LOG_FILE
    exit 1
fi
if pgrep -f "aws sso login" > /dev/null; then
    echo "[$(date)] An AWS SSO login process is already running. Skipping new login attempt." | tee -a $LOG_FILE
    exit 0
fi
echo "[$(date)] Checking if AWS session is valid..." | tee -a $LOG_FILE
if aws sts get-caller-identity --profile "$AWS_PROFILE" &>/dev/null; then
    echo "[$(date)] AWS SSO session is valid. Skipping login." | tee -a $LOG_FILE
else
    echo "[$(date)] AWS SSO session is not valid. Logging in to all profiles..." | tee -a $LOG_FILE
    aws sso login --sso-session okta
    if [ $? -ne 0 ]; then
        echo "[$(date)] AWS SSO login failed. See onboarding steps at https://whoopinc.atlassian.net/wiki/spaces/AI/pages/4333044096/CodeArtifact+Setup" | tee -a $LOG_FILE
        exit 1
    fi
fi
echo "[$(date)] Generating CodeArtifact authorization token..." | tee -a $LOG_FILE
GET_AUTHORIZATION_TOKEN_OUTPUT=$(aws codeartifact get-authorization-token \
  --domain whoop \
  --domain-owner 688238828846 \
  --region us-west-2 \
  --duration-seconds 0 \
  --output json \
  --profile "$AWS_PROFILE")
CODEARTIFACT_AUTH_TOKEN=$(echo "$GET_AUTHORIZATION_TOKEN_OUTPUT" | sed -n 's/.*"authorizationToken": "\([^"]*\)".*/\1/p')
CODEARTIFACT_AUTH_TOKEN_EXPIRATION=$(echo "$GET_AUTHORIZATION_TOKEN_OUTPUT" | sed -n 's/.*"expiration": "\([^"]*\)".*/\1/p')
if [[ -z "$CODEARTIFACT_AUTH_TOKEN" ]]; then
    echo "[$(date)] Failed to retrieve CodeArtifact authorization token. See onboarding steps at https://whoopinc.atlassian.net/wiki/spaces/AI/pages/4333044096/CodeArtifact+Setup" | tee -a $LOG_FILE
    exit 1
else
    date +%s > "$LAST_RUN_FILE"
fi
if [ -f $HOME/.m2/settings.xml ]; then
    echo "[$(date)] Updating Maven settings.xml with CodeArtifact token..." | tee -a $LOG_FILE
    sed -i.bak "s|<password>.*</password>|<password>$CODEARTIFACT_AUTH_TOKEN</password>|g" $HOME/.m2/settings.xml
else
    echo "[$(date)] Maven settings.xml not found at $HOME/.m2/settings.xml, skipping Maven auth update." | tee -a $LOG_FILE
fi
if command -v npm &>/dev/null; then
    echo "[$(date)] Generating NPM credentials..." | tee -a $LOG_FILE
    aws codeartifact login --tool npm --domain whoop --domain-owner 688238828846 --repository whoop-npm --region us-west-2 --profile "$AWS_PROFILE" | tee -a $LOG_FILE
else
    echo "[$(date)] npm not found. Skipping npm authentication." | tee -a $LOG_FILE
fi
if command -v pip &>/dev/null; then
    echo "[$(date)] Generating pip credentials..." | tee -a $LOG_FILE
    aws codeartifact login --tool pip --domain whoop --domain-owner 688238828846 --repository whoop-pypi --region us-west-2 --profile "$AWS_PROFILE" | tee -a $LOG_FILE
else
    echo "[$(date)] pip not found. Skipping pip authentication." | tee -a $LOG_FILE
fi
if command -v poetry &>/dev/null; then
    echo "[$(date)] Configuring Poetry with CodeArtifact credentials..." | tee -a $LOG_FILE
    PYTHON_KEYRING_BACKEND="keyring.backends.null.Keyring" poetry config http-basic.whoop-pypi aws "$CODEARTIFACT_AUTH_TOKEN" --no-interaction | tee -a $LOG_FILE
else
    echo "[$(date)] Poetry not found. Skipping Poetry authentication." | tee -a $LOG_FILE
fi
echo "[$(date)] Successfully authenticated with CodeArtifact!" | tee -a $LOG_FILE
EOL
chmod +x $HOME/.aws/codeartifact_auth.sh
