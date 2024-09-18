#!/bin/bash
set -e

EXTRACTOR_DIR=/extractor
CLIENT_DIR=${EXTRACTOR_DIR}/client
RESOURCES_DIR=${EXTRACTOR_DIR}/resources
TOOLS_DIR=/usr/local/skyfire-server/bin

cd "${CLIENT_DIR}"
${TOOLS_DIR}/mapextractor
${TOOLS_DIR}/vmap4extractor
${TOOLS_DIR}/vmap4assembler

output_files="
    Buildings
    cameras
    db2
    dbc
    maps
    vmaps
"

echo "Moving extractor output to resources dir..."
mkdir -p ${EXTRACTOR_DIR}/resources
for output_file in ${output_files}; do
    mv "${CLIENT_DIR}/${output_file}" "${RESOURCES_DIR}"
done

echo "Extraction done"
