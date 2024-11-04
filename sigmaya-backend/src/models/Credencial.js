import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

import { Estado } from "./Estado.js";
import { Usuario } from "./Usuario.js";

// tbl_credenciales

export const Credencial = sequelize.define("Credencial", {
  credencial_id: {
    type: DataTypes.BIGINT,
    autoIncrement: true,
    primaryKey: true,
  },
  usuario_id: {
    type: DataTypes.CHAR(9),
    references: {
      model: Usuario,
      key: 'usuario_id'
    }
  },
  username: {
    type: DataTypes.STRING,
    unique: true,
  },
  password_hash: {
    type: DataTypes.STRING,
  },
  fecha_creacion: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  fecha_expiracion_password: {
    type: DataTypes.DATE,
    defaultValue: sequelize.literal("CURRENT_DATE + INTERVAL '90 days'"),
  },
  intentos_fallidos: {
    type: DataTypes.INTEGER,
  },
  fecha_ultimo_acceso: {
    type: DataTypes.DATE,
  },
  ip_ultimo_acceso: {
    type: DataTypes.STRING,
  },
  bloqueado: {
    type: DataTypes.BOOLEAN,
  },
  estado_id: {
    type: DataTypes.SMALLINT,
    references: {
      model: Estado,
      key: 'estado_id'
    }
  }
}, { tableName: "tbl_credenciales" });

Credencial.belongsTo(Usuario, { foreignKey: 'usuario_id' });
Credencial.belongsTo(Estado, { foreignKey: 'estado_id' });