# Any YML config files should be loaded in this file

LAST_FM = YAML.load_file("#{::Rails.root.to_s}/config/last_fm.yml")
YOUTUBE = YAML.load_file("#{::Rails.root.to_s}/config/youtube.yml")
