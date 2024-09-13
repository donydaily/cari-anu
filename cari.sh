#!/bin/bash

clear

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
WHITE='\033[0;37m'
NC='\033[0m'

GREENN=$(tput setaf 2)
RESET=$(tput sgr0)


echo -e "${RED}-_-_-_┏┓    •   ┏┓-_-_-_-_-_${NC}"
echo -e "${RED}_-_-_-┃ ┏┓┏┓┓ ━ ┣┫┏┓┓┏_-_-_-${NC}"
echo -e "${RED}-_-_-_┗┛┗┻┛ ┗   ┛┗┛┗┗┻-_-_-_${NC}"

echo -n "${GREENN}Direktori target : ${RESET}"
read search_directory
echo -n "${GREENN}Teks pencarian : ${RESET}"
read patterns
echo -n "${GREENN}Format file : ${RESET}"
read file_formats

#
if [ -z "$search_directory" ] || [ -z "$patterns" ] || [ -z "$file_formats" ]; then
    echo -e "${RED}Direktori target, teks pencarian, dan format file tidak boleh kosong!${NC}"
    exit 1

fi
#
patterns=$(echo "$patterns" | sed 's/,/|/g')

#
IFS=',' read -r -a formats <<< "$file_formats"

#
for format in "${formats[@]}"; do
    echo -e "${YELLOW}Mencari teks dalam file *.$format...${NC}"
    grep -rn -E "$patterns" --include="*.$format" "$search_directory" | while IFS= read -r line; do
        #
        full_file_path=$(echo "$line" | cut -d: -f1)
        line_number=$(echo "$line" | cut -d: -f2)
        content=$(echo "$line" | cut -d: -f3-)

        #
        relative_file_path=$(echo "$full_file_path" | sed "s|$search_directory/||")

        #
        content=$(echo "$content" | sed 's/^[ \t]*//;s/[ \t]*$//')

        #
        echo -e "${GREEN}File:${NC} ${WHITE}$relative_file_path${NC}"
        echo -e "${GREEN}Line Number:${NC} ${WHITE}$line_number${NC}"
        echo -e "${GREEN}Content:${NC} ${WHITE}$content${NC}"
        echo -e "${RED}------------------------------------${NC}"
    done
done
