#!/bin/bash
this_dir=$(pwd)

ua_h=$(<"$this_dir/ua.txt")

echo "Building recon scripts and various one-liners"
sleep 1

touch "$this_dir/subfinder.wildcards.sh"
chmod +x "$this_dir/subfinder.wildcards.sh"
cat <<EOL > "$this_dir/subfinder.wildcards.sh"
#!/bin/bash

# Subfinder and ffuf script to look for subdomains

subfinder TODO
EOL

touch "$this_dir/ffuf-subdomain.wildcards.sh"
chmod +x "$this_dir/ffuf-subdomain.wildcards.sh"
cat <<EOL > "$this_dir/ffuf-subdomain.wildcards.sh"
#!/bin/bash
for URL in \$(<scopes.wildcards.domains.txt); do
   ffuf -mc 200 -w ~/wordlists/subdomains_all.txt -u FUZZ.\$URL -ac -H "$ua_h"
done
EOL

clear
echo "'$this_dir' recon scripts ready, happy hunting!"
sleep 1
