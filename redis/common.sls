{% set redis = pillar.get('redis', {}) -%}
{% set version = redis.get('version', '2.8.4') -%}
{% set checksum = redis.get('checksum', 'sha1=79b156cc9d8bff5a022fdc6d28d5c42999ddcb4f') -%}
{% set root = redis.get('root', '/usr/local') -%}

redis-dependencies:
  pkg.installed:
    - names:
        - build-essential
        - python-dev
        - libxml2-dev

## Get redis
get-redis:
  file.managed:
    - name: {{ root }}/redis-{{ version }}.tar.gz
    - source: http://download.redis.io/releases/redis-{{ version }}.tar.gz
    - source_hash: {{ checksum }}
    - require:
      - pkg: redis-dependencies
  cmd.wait:
    - cwd: {{ root }}
    - names:
      - tar -zxvf {{ root }}/redis-{{ version }}.tar.gz -C {{ root }}
    - watch:
      - file: get-redis

make-redis:
  cmd.wait:
    - cwd: {{ root }}/redis-{{ version }}
    - names:
      - make
      - make install
    - watch:
      - cmd: get-redis