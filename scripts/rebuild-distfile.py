#!/usr/bin/env python3

import os
import sys
import xml.etree.ElementTree as ET
import pprint as pp

from urllib.parse import urlparse

query_cmd = './bin/bazel-6.2.0-linux-x86_64 query "kind(http_archive, //external:*)" --output xml > ./bazel-out/deps.xml'
query_result = os.system(query_cmd)

tree = ET.parse('./bazel-out/deps.xml')
root = tree.getroot()
deps = []
for child in root.findall("rule[@class='http_archive']"):
    # parse name
    name = child.find("*[@name='name']").attrib['value']
    if not os.path.exists(f"./external/{name}"):
        print(f"./external/{name} not exists, so ignore it")
        continue
    # parse sha256
    sha256_item = child.find("*[@name='sha256']")
    if sha256_item is not None:
        sha256 = sha256_item.attrib['value']
    else:
        sha256 = ''
    # parse strip_prefix
    sp_item = child.find("*[@name='strip_prefix']")
    if sp_item is not None:
        strip_prefix = sp_item.attrib['value']
    else:
        strip_prefix = ''

    # parse urls
    urls_item = child.find("list[@name='urls']")
    if urls_item is None:
        continue
    urls = []
    for item in urls_item.getchildren():
        urls.append(item.attrib['value'])
    deps.append({
        'name': name,
        'sha256': sha256,
        'strip_prefix': strip_prefix,
        'urls': urls,
    })

infos = {}
for dep in deps:
    if len(dep['urls']) == 0:
        continue
    info = {
        'urls': dep['urls'],
        'sha256': dep['sha256'],
        'strip_prefix': dep['strip_prefix']
    }
    archive = os.path.basename(urlparse(dep['urls'][0]).path)
    info['archive'] = archive
    if (archive.count('-') == 0 and
        archive.count('_') == 0):
        info['distdir'] = dep['name']
    info['used_in'] = [
        "additional_distfiles",
    ]
    infos[dep['name']] = info

import json
with open('./full_deps.bzl', 'wt') as f:
    f.write('FULL_DEPS = \\\n')
    f.write(json.dumps(infos, indent=4))

print(f"Total {len(deps)} dependencies")
print("Done")
