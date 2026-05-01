#!/bin/bash
python3 << 'PYEOF'
with open('src/components/Hero.js', 'r') as f:
    lines = f.readlines()

output = []
skip = False
depth = 0
for line in lines:
    if 'hero__stats' in line and 'className' in line:
        skip = True
        depth = 0
    if skip:
        depth += line.count('<div') - line.count('</div') - line.count('/>')
        if depth <= 0 and '</div>' in line:
            skip = False
        continue
    output.append(line)

with open('src/components/Hero.js', 'w') as f:
    f.writelines(output)

print('Stats row removed!')
PYEOF
echo "✅ Done!"
