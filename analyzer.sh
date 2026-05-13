#!/bin/bash

# ------------------LOG ANALYZER AUTOMATION APP---------------------

clear

echo "---------------------  LOG ANALYZER SYSTEM -----------------"
echo 
echo

echo "Generated on : $(date "+%d-%m-%Y %H:%M:%S")"


FILE=$1

# Check if file exists
if ! [[  -f "$FILE" ]]
then
    echo "Error: File does not exist"
    exit 1
fi

# Check .log extension
if [[ "$FILE" != *.log ]]
then
    echo "Error: not a log file"
    exit 1
fi

echo "Analyzing file: $FILE"
echo

TOTAL_LINES=$(wc -l < "$FILE")

# Count logs
ERROR_COUNT=$(grep -c "ERROR" "$FILE")
WARNING_COUNT=$(grep -c "WARNING" "$FILE")
INFO_COUNT=$(grep -c "INFO" "$FILE")

# Colors
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
BLUE='\e[34m'
NC='\e[0m'

echo "========== LOG SUMMARY =========="

echo -e "${RED}Total Errors   : $ERROR_COUNT${NC}"
echo -e "${YELLOW}Total Warnings : $WARNING_COUNT${NC}"
echo -e "${GREEN}Total Info     : $INFO_COUNT${NC}"

echo
echo -e "${BLUE}Total Lines    : $TOTAL_LINES${NC}"

echo
echo "========== ERROR LINES =========="
echo 
# ERROR lines with line numbers using awk
awk '
/ERROR/ {
    print "Line " NR ": " $0
}
' "$FILE"

echo
echo "========== WARNING LINES =========="
echo 
awk '
/WARNING/ {
    print "Line " NR ": " $0
}
' "$FILE"

echo
echo "========== INFO LINES =========="
echo
awk '
/INFO/ {
    print "Line " NR ": " $0
}
' "$FILE"

# Cleaned log file
sed 's/ERROR/CHECKED/g' "$FILE" > cleaned.log

echo
echo -e "${GREEN}Cleaned log file generated: cleaned.log${NC}"

# Log report
{
echo "========== REPORT =========="
echo 
echo "Generated on: $(date)"
echo
echo "File Name      : $FILE"
echo "Total Lines    : $TOTAL_LINES"
echo "Total Errors   : $ERROR_COUNT"
echo "Total Warnings : $WARNING_COUNT"
echo "Total Info     : $INFO_COUNT"
} > report.txt

echo -e "${GREEN}Report generated: report.txt${NC}"

{
echo "========== FILE PROPERTIES =========="
echo

echo "Generated on: $(date "+%d-%m-%y %H:%M:%S")"
echo 

echo "File Name: $(basename "$FILE")"

echo "File Type: $(file "$FILE")"

echo "File Size: $(du -h "$FILE")"
echo 

echo "Permissions: $(ls -l "$FILE")"

[ -r "$FILE" ] && echo "Readable: Yes"
[ -w "$FILE" ] && echo "Writable: Yes"

echo "$(stat "$FILE" | grep Modify)"
echo 

echo "Log Type Frequency:"
awk '{print $1}' "$FILE" | sort | uniq -c

} > file_properties.txt

echo -e "${GREEN}File properties generated: file_properties.txt${NC}"
echo
echo
echo "-------------------- ANALYSIS COMPLETED -----------------"
echo 
