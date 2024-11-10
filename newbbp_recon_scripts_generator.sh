#!/bin/bash
this_dir=$(pwd)
ua_h=$(cat "$this_dir/ua.txt")

echo "Building recon scripts and various one-liners"
sleep 1; 

# ffuf_subdomains_wildcards.sh
touch "$this_dir/ffuf_subdomains_wildcards.sh"
chmod +x "$this_dir/ffuf_subdomains_wildcards.sh"
cat <<EOL > "$this_dir/ffuf_subdomains_wildcards.sh"
#!/bin/bash
#TODO
EOL

# subfinder_wildcards.sh
touch "$this_dir/subfinder_wildcards.sh"
chmod +x "$this_dir/subfinder_wildcards.sh"
cat <<EOL > "$this_dir/subfinder_wildcards.sh"
#!/bin/bash
#subfinder script to look and filter alive subdomains

subfinder -dL scopes.wildcards.domains.txt -all -max-time 5 -timeout 15 -o recon.subfinder.subdomains.txt
cat recon.subfinder.subdomains.txt | httpx -ports 443,80,8080,3000,8888 -mc 200 -o 200.recon.subfinder.subdomains.txt -H "$ua_h" -debug -v 

EOL

# subfinder_recursive_wildcards
touch "$this_dir/subfinder_recursive_wildcards.sh"
chmod +x "$this_dir/subfinder_recursive_wildcards.sh"
cat <<EOL > "$this_dir/subfinder_recursive_wildcards.sh"
#!/bin/bash

#subfinder script to look and filter alive subdomains, recursive mode

subfinder -dL scopes.wildcards.domains.txt -recursive -all -max-time 5 -timeout 15 -o recon.subfinder.recursive.subdomains.txt
cat recon.subfinder.recursive.subdomains.txt | httpx -ports 443,80,8080,3000,8888 -mc 200 -o 200.recon.subfinder.recursive.subdomains.txt -H "$ua_h" -debug -v 

EOL

# compile_subdomains.sh
touch "$this_dir/compile_subdomains.sh"

chmod +x "$this_dir/compile_subdomains.sh"
cat <<EOL > "$this_dir/compile_subdomains.sh"
#!/bin/bash
touch recon.subdomains.txt
cat recon.ffuf.subdomains.txt > recon.subdomains.txt
cat 200.recon.subfinder.subdomains.txt >> recon.subdomains.txt
cat 200.recon.subfinder.recursive.subdomains.txt >> recon.subdomains.txt

cat recon.subdomains.txt | sort | uniq | cat > tmp 
cat tmp recon.subdomains.txt

rm -Rf 200.recon.subfinder.subdomains.txt 
rm -Rf 200.recon.subfinder.recursive.subdomains.txt 
rm -Rf recon.subfinder.subdomains.txt 
rm -Rf recon.subfinder.recursive.subdomains.txt 
rm -Rf recon.ffuf.subdomains.txt
rm -Rf tmp

EOL

echo "'$this_dir' recon scripts ready, happy hunting!"
sleep 1
