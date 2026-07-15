#!/bin/bash
#
# Extract nghttp2-asio sources, apply patches, and generate combined diff.
#
# Usage:
#   ./extract-sources.sh [--clean]
#
# Output:
#   ./sources/nghttp2-asio/                - upstream (cached, reused across runs)
#   ./sources/nghttp2-asio.patched/        - patched copy
#   ./sources/nghttp2-asio.patched.patch   - combined diff (patch -p1 compatible)
#
# Use --clean to remove cached sources and force a fresh download.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PATCHES_DIR="${SCRIPT_DIR}/patches/nghttp2-asio/main"
SOURCES_DIR="${SCRIPT_DIR}/sources"
OUTPUT_ORIGINAL="${SOURCES_DIR}/nghttp2-asio"
OUTPUT_PATCHED="${SOURCES_DIR}/nghttp2-asio.patched"
OUTPUT_DIFF="${SOURCES_DIR}/nghttp2-asio.global-patch"
NGHTTP2_ASIO_BRANCH="main"

if [ "$1" = "--clean" ]; then
    rm -rf "${OUTPUT_ORIGINAL}" "${OUTPUT_PATCHED}" "${OUTPUT_DIFF}"
    echo "Cleaned."
    exit 0
fi

# Download upstream only if not cached
if [ ! -d "${OUTPUT_ORIGINAL}" ]; then
    TMPDIR=$(mktemp -d)
    trap "rm -rf ${TMPDIR}" EXIT

    echo "Downloading nghttp2-asio (branch: ${NGHTTP2_ASIO_BRANCH})..."
    wget -q -O "${TMPDIR}/${NGHTTP2_ASIO_BRANCH}.zip" \
        "https://github.com/nghttp2/nghttp2-asio/archive/refs/heads/${NGHTTP2_ASIO_BRANCH}.zip"
    unzip -q "${TMPDIR}/${NGHTTP2_ASIO_BRANCH}.zip" -d "${TMPDIR}"
    mkdir -p "${SOURCES_DIR}"
    mv "${TMPDIR}/nghttp2-asio-${NGHTTP2_ASIO_BRANCH}" "${OUTPUT_ORIGINAL}"
    echo "Cached: ${OUTPUT_ORIGINAL}"
else
    echo "Using cached upstream: ${OUTPUT_ORIGINAL}"
fi

# Generate patched copy
[ -d "${OUTPUT_PATCHED}" ] && rm -r "${OUTPUT_PATCHED}"
cp -a "${OUTPUT_ORIGINAL}" "${OUTPUT_PATCHED}"

echo "Applying patches:"
for patch in $(ls "${PATCHES_DIR}"/*.patch 2>/dev/null | sort); do
    echo "  $(basename ${patch})"
    patch -d "${OUTPUT_PATCHED}" -p1 -s < "${patch}"
done

# Generate combined diff
diff -Naur "${OUTPUT_ORIGINAL}" "${OUTPUT_PATCHED}" \
    | sed "s|${OUTPUT_ORIGINAL}|a|g; s|${OUTPUT_PATCHED}|b|g" \
    > "${OUTPUT_DIFF}" || true

echo ""
echo "Done:"
echo "  Upstream: ${OUTPUT_ORIGINAL}"
echo "  Patched:  ${OUTPUT_PATCHED}"
echo "  Diff:     ${OUTPUT_DIFF}"
