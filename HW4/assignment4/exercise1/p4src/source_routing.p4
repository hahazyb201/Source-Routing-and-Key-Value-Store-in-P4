/*
Copyright 2013-present Barefoot Networks, Inc. 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// TODO: define headers & header instances
header_type easy_route_header{
    fields{
        preamble: 64;
        num_valid: 32;
    }
}

header_type easy_route_port{
    fields{
        port1: 8;
    }
}

header easy_route_header e_head;
header easy_route_port e_port;

parser start {
    // TODO
    return select(current(0,64)){
        0: extract_head;
        default: ingress;
    }
}

// TODO: define parser states
parser extract_head{
    extract(e_head);
    return select(latest.num_valid){
        0: ingress;
        default: extract_port1;
    }
}

parser extract_port1{
    extract(e_port);
    return ingress;
}

action _drop() {
    drop();
}

action route() {
    modify_field(standard_metadata.egress_spec, e_port.port1/* TODO: port field from your header */);
    // TODO: update your header
    add_to_field(e_head.num_valid,-1);
    remove_header(e_port);
}

//action
control ingress {
    // TODO
    apply(easy_route);
}

control egress {
    // leave empty
}

table easy_route{
    reads{
        e_port.port1: exact;
    }
    actions{
        _drop;
        route;
    }
}
