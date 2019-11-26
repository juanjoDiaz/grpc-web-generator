# gRPC-web generator

gRPC-web generator helps you generate your javascript gRPC-web files without having to install anything in your machine.

See [gRPC-web](https://github.com/grpc/grpc-web) for more details.

I assume that in the future there will be a official npm package to generate the necessary grpc-web files. Until that happens, gRPC-web generator uses a docker container containing all the necessary dependencies to run the code generation process.

### Requirements

- Docker

## Configuration

To comunicate between the container and the host, we expect the folder with the protofile and anything else that you wish to include in the generation to be mounted on `/protofile`

You can configure how to files are generated passing the following environment variables

#### protofile

Defines the name of the proto file to use.

Defaults to `protofile=echo.proto`.

It's expected to be somewhere inside `/protofile`.

#### output

The output files will be saved to `$output`.

Defaults to `output=/protofile/generated`.

If you use other folder, please ensure that it's a mounted volume so the files end up in your host.

#### import_style

See more details at [gRPC-web](https://github.com/grpc/grpc-web).

Defaults to `commonjs`.

`import_style=closure`: The default generated code has Closure goog.require() import style.

`import_style=commonjs`: The CommonJS style require() is also supported.

**Note: `commonjs+dts` and `typescript` are only supported by the `grpc-web_out` plugin. You should use an extra environment variable as shown bellow:**

`grpc_web_import_style=commonjs+dts`: (Experimental) In addition to above, a .d.ts typings file will also be generated for the protobuf messages and service stub.

`grpc_web_import_style=typescript`: (Experimental) The service stub will be generated in TypeScript.

#### mode
For more information about the gRPC-Web wire format, please see the specification at [gRPC-web](https://github.com/grpc/grpc-web).

Defaults to `grpcwebtext`.

`mode=grpcwebtext`: The default generated code sends the payload in the grpc-web-text format.

- `Content-type: application/grpc-web-text`
- Payload are base64-encoded.
- Both unary and server streaming calls are supported.

`mode=grpcweb`: A binary protobuf format is also supported.

- `Content-type: application/grpc-web+proto`
- Payload are in the binary protobuf format.
- Only unary calls are supported for now.

## How to get the image

### From DockerHub

The image is available at [Docker Hub](https://hub.docker.com/r/juanjodiaz/grpc-web-generator/)

```sh
docker pull juanjodiaz/grpc-web-generator
```

### Build from source

```bash
docker build <path_to_this_repository> -t juanjodiaz/grpc-web-generator
```

## Generating the files

```bash
  docker run \
    -v "<MY_INCLUDES_FOLDER>:/protofile" \
    -e "protofile=<MY_PROTO_FILE>.proto" \
    juanjodiaz/grpc-web-generator
```

## Integrating it in your npm build

You can add a script to your NPM file like:
```json
{
  "name": "my projects",

  ...

  "scripts": {
    "grpc.generate": "docker run -v \"<MY_INCLUDES_FOLDER>:/protofile\" -e \"protofile=<MY_PROTO_FILE>.proto\" juanjodiaz/grpc-web-generator:1.0.5"
  },

  ...
}

```

and then run it as:
```bash
  npm run grpc.generate
```

## License

MIT
