# Optional switch to dev branch (if pushing to main/master is restricted)
# git checkout dev

# configure nvm, modejs, and fix project for spfx
. ${NVM_DIR}/nvm.sh
npm config delete prefix
nvm install 10
npm install -g gulp

# add *.cer to .gitignore to prevent certificates from being saved in repo
if ! grep -Fxq '*.cer' ./.gitignore
then
  echo "# Certificates" >> .gitignore
  echo "*.cer" >> .gitignore
fi

npm install

# commands to create dev certificate and copy it to the root folder of the project
gulp trust-dev-cert
cp /home/codespace/.gcb-serve-data/gcb-serve.cer ./SPFx-Dev-Cert.cer

# Download the cert to Windows download folder for the following command(s)
# Run from Windows cmd prompt
# certutil -user -addstore root %USERPROFILE%\downloads\spfx-dev-cert.cer
# OR
# Run the following Powershell command (from elevated/admin prompt)
# Import-Certificate -FilePath "$env:USERPROFILE\downloads\spfx-dev-cert.cer" -CertStoreLocation Cert:\LocalMachine\Root
