use("MarketDB");

// CREACIÓN DE COLECCIONES

db.createCollection("comentarios", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["id_comentario", "id_usuario", "id_producto",
                 "contenido", "fecha_comentario", "estado_comentario", "is_delete"],
      properties: {
        id_comentario:       { bsonType: "string" },
        id_usuario:          { bsonType: "string" },
        id_producto:         { bsonType: "string" },
        id_comentario_padre: { bsonType: ["string", "null"] },
        contenido:           { bsonType: "string" },
        fecha_comentario:    { bsonType: "date" },
        estado_comentario:   { bsonType: "string",
                               enum: ["activo", "oculto", "eliminado", "reportado"] },
        is_delete:           { bsonType: "bool" },
        delete_date:         { bsonType: ["date", "null"] }
      }
    }
  }
});

db.createCollection("resenyas", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["id_resenya", "id_usuario_evaluador", "id_usuario_evaluado",
                 "id_producto", "calificacion_estrellas", "comentario",
                 "fecha_resenya", "is_delete"],
      properties: {
        id_resenya:             { bsonType: "string" },
        id_usuario_evaluador:   { bsonType: "string" },
        id_usuario_evaluado:    { bsonType: "string" },
        id_producto:            { bsonType: "string" },
        calificacion_estrellas: { bsonType: "int", minimum: 1, maximum: 5 },
        comentario:             { bsonType: "string" },
        fecha_resenya:          { bsonType: "date" },
        is_delete:              { bsonType: "bool" },
        delete_date:            { bsonType: ["date", "null"] }
      }
    }
  }
});

db.createCollection("guardados", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["id_guardado", "id_usuario", "id_producto",
                 "fecha_guardada", "is_delete"],
      properties: {
        id_guardado:     { bsonType: "string" },
        id_usuario:      { bsonType: "string" },
        id_producto:     { bsonType: "string" },
        fecha_guardada:  { bsonType: "date" },
        is_delete:       { bsonType: "bool" },
        delete_date:     { bsonType: ["date", "null"] }
      }
    }
  }
});

db.createCollection("denuncias", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["id_denuncia", "id_usuario", "id_producto",
                 "motivo", "descripcion_denuncia", "fecha_denuncia",
                 "estado_denuncia", "is_delete"],
      properties: {
        id_denuncia:          { bsonType: "string" },
        id_usuario:           { bsonType: "string" },
        id_producto:          { bsonType: "string" },
        motivo:               { bsonType: "string" },
        descripcion_denuncia: { bsonType: "string" },
        fecha_denuncia:       { bsonType: "date" },
        estado_denuncia:      { bsonType: "string",
                                enum: ["pendiente", "revisada", "aceptada", "rechazada"] },
        is_delete:            { bsonType: "bool" },
        delete_date:          { bsonType: ["date", "null"] }
      }
    }
  }
});

// INSERCIÓN DE DATOS

db.comentarios.insertMany([
  {
    id_comentario: "C001", id_usuario: "U001", id_producto: "P001",
    id_comentario_padre: null,
    contenido: "¿Alguien ha probado este smartphone?",
    fecha_comentario: new Date("2024-06-08"), estado_comentario: "activo",
    is_delete: false, delete_date: null
  },
  {
    id_comentario: "C002", id_usuario: "U002", id_producto: "P001",
    id_comentario_padre: "C001",
    contenido: "Sí, lo compré la semana pasada y funciona muy bien.",
    fecha_comentario: new Date("2024-06-08"), estado_comentario: "activo",
    is_delete: false, delete_date: null
  },
  {
    id_comentario: "C003", id_usuario: "U003", id_producto: "P002",
    id_comentario_padre: null,
    contenido: "¿Alguien ha tenido problemas con esta laptop?",
    fecha_comentario: new Date("2024-06-09"), estado_comentario: "activo",
    is_delete: false, delete_date: null
  },
  {
    id_comentario: "C004", id_usuario: "U004", id_producto: "P003",
    id_comentario_padre: null,
    contenido: "El vestido es bonito pero la talla varía.",
    fecha_comentario: new Date("2024-06-09"), estado_comentario: "activo",
    is_delete: false, delete_date: null
  },
  {
    id_comentario: "C005", id_usuario: "U005", id_producto: "P004",
    id_comentario_padre: null,
    contenido: "El sofá llegó en buen estado, lo recomiendo.",
    fecha_comentario: new Date("2024-06-10"), estado_comentario: "activo",
    is_delete: false, delete_date: null
  }
]);

db.resenyas.insertMany([
  {
    id_resenya: "R001", id_usuario_evaluador: "U001", id_usuario_evaluado: "U002",
    id_producto: "P001", calificacion_estrellas: 5,
    comentario: "Excelente producto, muy satisfecho con la compra.",
    fecha_resenya: new Date("2024-06-05"), is_delete: false, delete_date: null
  },
  {
    id_resenya: "R002", id_usuario_evaluador: "U001", id_usuario_evaluado: "U002",
    id_producto: "P002", calificacion_estrellas: 4,
    comentario: "La laptop es buena pero el envío fue lento.",
    fecha_resenya: new Date("2024-06-08"), is_delete: false, delete_date: null
  },
  {
    id_resenya: "R003", id_usuario_evaluador: "U002", id_usuario_evaluado: "U001",
    id_producto: "P003", calificacion_estrellas: 3,
    comentario: "El vestido es bonito pero la talla no me quedó bien.",
    fecha_resenya: new Date("2024-06-07"), is_delete: false, delete_date: null
  },
  {
    id_resenya: "R004", id_usuario_evaluador: "U003", id_usuario_evaluado: "U002",
    id_producto: "P001", calificacion_estrellas: 2,
    comentario: "La batería dura muy poco.",
    fecha_resenya: new Date("2024-06-08"), is_delete: false, delete_date: null
  },
  {
    id_resenya: "R005", id_usuario_evaluador: "U004", id_usuario_evaluado: "U002",
    id_producto: "P002", calificacion_estrellas: 5,
    comentario: "Laptop muy rápida y fácil de usar.",
    fecha_resenya: new Date("2024-06-09"), is_delete: false, delete_date: null
  }
]);

db.guardados.insertMany([
  {
    id_guardado: "G001", id_usuario: "U001", id_producto: "P001",
    fecha_guardada: new Date("2024-06-09"), is_delete: false, delete_date: null
  },
  {
    id_guardado: "G002", id_usuario: "U001", id_producto: "P002",
    fecha_guardada: new Date("2024-06-09"), is_delete: false, delete_date: null
  },
  {
    id_guardado: "G003", id_usuario: "U002", id_producto: "P003",
    fecha_guardada: new Date("2024-06-09"), is_delete: false, delete_date: null
  },
  {
    id_guardado: "G004", id_usuario: "U003", id_producto: "P001",
    fecha_guardada: new Date("2024-06-09"), is_delete: false, delete_date: null
  },
  {
    id_guardado: "G005", id_usuario: "U004", id_producto: "P002",
    fecha_guardada: new Date("2024-06-09"), is_delete: false, delete_date: null
  }
]);

db.denuncias.insertMany([
  {
    id_denuncia: "D001", id_usuario: "U001", id_producto: "P003",
    motivo: "Producto defectuoso",
    descripcion_denuncia: "El producto llegó con un agujero en la tela.",
    fecha_denuncia: new Date("2024-06-10"), estado_denuncia: "pendiente",
    is_delete: false, delete_date: null
  },
  {
    id_denuncia: "D002", id_usuario: "U002", id_producto: "P001",
    motivo: "Publicidad engañosa",
    descripcion_denuncia: "El smartphone no tiene las características anunciadas.",
    fecha_denuncia: new Date("2024-06-10"), estado_denuncia: "revisada",
    is_delete: false, delete_date: null
  },
  {
    id_denuncia: "D003", id_usuario: "U003", id_producto: "P002",
    motivo: "Mala atención al cliente",
    descripcion_denuncia: "Tuve problemas para contactar al vendedor.",
    fecha_denuncia: new Date("2024-06-10"), estado_denuncia: "pendiente",
    is_delete: false, delete_date: null
  },
  {
    id_denuncia: "D004", id_usuario: "U004", id_producto: "P004",
    motivo: "Producto no entregado",
    descripcion_denuncia: "Realicé el pedido pero nunca recibí el sofá.",
    fecha_denuncia: new Date("2024-06-10"), estado_denuncia: "revisada",
    is_delete: false, delete_date: null
  },
  {
    id_denuncia: "D005", id_usuario: "U005", id_producto: "P005",
    motivo: "Producto dañado",
    descripcion_denuncia: "La bicicleta llegó con la rueda trasera dañada.",
    fecha_denuncia: new Date("2024-06-10"), estado_denuncia: "pendiente",
    is_delete: false, delete_date: null
  }
]);