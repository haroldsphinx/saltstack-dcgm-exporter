{%- from slspath + '/map.jinja' import dcgmexporter with context -%}

"DCGM Exporter: Create group":
  group.present:
    - name: {{ dcgmexporter.group }}

"DCGM Exporter: Create user":
  user.present:
    - name: {{ dcgmexporter.user }}
    - groups:
      - {{ dcgmexporter.group }}
    - createhome: False
    - system: True
    - require:
      - group: "DCGM Exporter: Create group"

"DCGM Exporter: Create metrics directory":
  file.directory:
    - name: /var/lib/prometheus/dcgm_exporter
    - user: {{ dcgmexporter.user }}
    - group: {{ dcgmexporter.group }}
    - makedirs: True
    - dir_mode: 775

"DCGM Exporter: Clone DCGM Repo":
  git.latest:
    - name: {{ dcgm_exporter_git_url }}
    - target: /tmp/nvidia_dcgm_exporter
    - branch: {{ dcgm_exporter_version }}

"DCGM Exporter: Compile DCGM Exporter Binary":
  cmd.run:
    - name: make binary
    - cwd: /tmp/nvidia_dcgm_exporter
    - env:
        PATH: /tmp/go/bin:{{ salt['environ.get']('PATH') }}
        GOPATH: /tmp/gopath
    - require:
      - git: "DCGM Exporter: Clone DCGM Repo"

"DCGM Exporter: Distribute Binary":
  file.managed:
    - name: /usr/local/bin/nvidia_dcgm_exporter
    - source: /tmp/nvidia_dcgm_exporter/cmd/dcgm-exporter/dcgm-exporter
    - user: root
    - group: root
    - mode: 0755
    - onchanges:
      - cmd: "DCGM Exporter: Compile DCGM Exporter Binary"


"DCGM Exporter: Change file permissions":
  file.managed:
    - name: /usr/local/bin/dcgm_exporter-{{ dcgmexporter.version }}
    - user: root
    - group: root
    - mode: 755
    - replace: False

"DCGM Exporter: Create symlink":
  file.symlink:
    - name: /usr/local/bin/dcgm_exporter
    - target: /usr/local/bin/dcgm_exporter-{{ dcgmexporter.version }}
    - force: True
    - watch:
      - file: "DCGM Exporter: Distribute Binary"

"DCGM Exporter: Create service file":
  file.managed:
    - name: /etc/systemd/system/dcgm_exporter.service
    - source: salt://{{ slspath }}/files/dcgm_exporter.service
    - user: root
    - group: root
    - template: jinja
    - mode: 0644
    - context:
        user: {{ dcgmexporter.user }}
        group: {{ dcgmexporter.group }}

"DCGM Exporter: Create pid directory":
  file.directory:
    - name: /var/run/prometheus
    - user: {{ dcgmexporter.user }}
    - makedirs: True
    - dir_mode: 755

"DCGM Exporter: Start servvice":
  service.running:
    - name: dcgm_exporter.service
    - enable: True
    - reload: True
    - watch:
      - file: "DCGM Exporter: Create env file"
      - file: "DCGM Exporter: Create service file"
      - file: "DCGM Exporter: Install dcgm_exporter"
