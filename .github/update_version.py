import sys
import yaml

def update_version(file_path, new_version):
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)

    data['version'] = new_version

    with open(file_path, 'w') as file:
        yaml.safe_dump(data, file, default_flow_style=False)

if __name__ == "__main__":
    file_path = sys.argv[1]
    new_version = sys.argv[2]
    update_version(file_path, new_version)
