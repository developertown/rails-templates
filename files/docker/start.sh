#!/bin/bash
rake db:migrate && rails server -b 0.0.0.0 -p 3000