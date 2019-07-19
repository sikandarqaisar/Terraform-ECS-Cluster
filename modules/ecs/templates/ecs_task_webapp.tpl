[
  {
    "name": "${containerName}",
    "image": "${webapp_docker_image}",
    "cpu": 128,
    "memory": 128,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": ${hostPort}
      }
    ],
    "command": [],
    "entryPoint": [],
    "links": [],
    "mountPoints": [],
    "volumesFrom": []
  }
]
