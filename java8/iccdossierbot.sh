#! /bin/sh

filePath=$1
now=$(date)

echo "Running $0... filePath=${filePath} $(date)"
echo "${now}" >> /var/log/appl/Batch/importfile/iccdossierbot.log


#curl -X POST http://localhost:10120/iccrea-import/iccrea-upload/dossier -F filePath=C:\\allfunds\\flash_project\\flh-java\\FileImport\\IccImporter\\src\\test\\resources\\ICC-47_1.xlsx -F ID_BRANCH=MIL -F ID_TRANSFER=3811290 -F NM_LOGIN=FLASH_MIL -F IMPORT_TYPE=IMICC >> iccdossierbot.log
curl -X POST http://localhost:10120/iccrea-import/iccrea-upload/dossier -F filePath=${filePath} -F ID_BRANCH=MIL -F ID_TRANSFER=0 -F NM_LOGIN=FLASH_MIL -F IMPORT_TYPE=IMICC >> /var/log/appl/Batch/importfile/iccdossierbot.log

echo "File iccdossierbot.log modified"
echo "" >> /var/log/appl/Batch/importfile/iccdossierbot.log
