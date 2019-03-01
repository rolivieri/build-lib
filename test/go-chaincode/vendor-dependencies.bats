#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../bats-mock/stub.bash"
load ../test_helper

setup() {
    src_dir="${BATS_TEST_DIRNAME}/../../src"
    testcase_dirname="$(mktemp -d)"

    setup_script_dir "${src_dir}" "${testcase_dirname}"
}

@test "vendor-dependencies.sh: should exist and be executable" {
    [ -x "${SCRIPT_DIR}/go-chaincode/vendor-dependencies.sh" ]
}

@test "vendor-dependencies.sh: fetch_dependencies should run without errors when .govendor_packages files does not exist" {

    cat << EOF > sample-config.json
{
  "org1": {
    "chaincode": [
      {
        "name": "contract1",
        "path": "chaincode/contract1",
        "channels": [ "channel1" ],
        "init_args": [],
        "instantiate": false,
        "install": true
      }
    ]
  },
  "org2": {
    "chaincode": [
      {
        "name": "contract1",
        "path": "chaincode/contract1",
        "channels": [ "channel1" ],
        "init_args": [],
        "instantiate": false,
        "install": true
      }
    ]
  }
}
EOF

    stub go \
        "get -u github.com/kardianos/govendor : true"

    source "${SCRIPT_DIR}/go-chaincode/vendor-dependencies.sh"

    run fetch_dependencies "sample-config.json"
 
    echo $output
    [ $status -eq 0 ]
   
    rm sample-config.json
    unstub go
}
