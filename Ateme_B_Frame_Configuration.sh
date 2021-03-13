#!/bin/bash
#================================================================
# HEADER
#================================================================
# DESCRIPTION
#    This is a script to automate disabling of hierarchical b-
#    frames in Titan Live 4.1.19.  To execute this script create
#    a list of encoder IP address in a text file labeled
#    IP_List.txt.  The results of the script will be available
#    in results.log.
#================================================================
#- IMPLEMENTATION
#-    version         1.0
#-    author          Luke Howell
#================================================================
#  HISTORY
#     2021/03/12 : lhowell : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================
for i in `cat IP_List.txt`;
    do
        if
            #
            echo "---------------------Starting encoder-----------------------"
            echo $i;
                curl -o AtemeServiceConfig.json --location --request GET "http://Administrator:titan@$i/api/v1/servicesmngt/services" \
                --header 'Content-Type: application/json' --silent --show-error

            str=$(cat AtemeServiceConfig.json);

            replaceValue='"EnableHierarchical": true'
            replaceWith='"EnableHierarchical": false'
            newStr=${str//$replaceValue/$replaceWith}
                echo $newStr > AtemeBFrameConfig.json;

            curl --location --request POST "http://$i/api/v1/servicesmngt/services?application=json" \
            --header 'Authorization: Basic QWRtaW5pc3RyYXRvcjp0aXRhbg==' \
            --header 'Content-Type: application/json' \
            --data-binary '@./AtemeBFrameConfig.json' --silent --show-error;
        then
            echo "Success!"
        else
            echo "!!!!!!!Fail!!!!!!!!!"
        fi
            #
            echo "---------------------Encoder finished------------------------"
done 2>&1 | tee results.log