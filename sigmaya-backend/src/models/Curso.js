import { DataTypes } from "sequelize";
import sequelize from "../config/database.js";

import { Estado } from "./Estado.js";
import { Materia } from "./Materia.js";

// tbl_cursos

export const Curso = sequelize.define("Curso", {
  curso_id: {
    type: DataTypes.CHAR(4),
    primaryKey: true,
  },
  materia_id: {
    type: DataTypes.CHAR(4),
    references: {
      model: Materia,
      key: 'materia_id'
    }
  },
  titulo: {
    type: DataTypes.STRING,
  },
  creditos: {
    type: DataTypes.INTEGER,
  },
  intensidad_horaria: {
    type: DataTypes.INTEGER,
  },
  contenido_tematico: {
    type: DataTypes.TEXT,
  },
  estado_id: {
    type: DataTypes.SMALLINT,
    references: {
      model: Estado,
      key: 'estado_id'
    }
  }
}, { tableName: "tbl_cursos" });

Curso.belongsTo(Materia, { foreignKey: 'materia_id' });
Curso.belongsTo(Estado, { foreignKey: 'estado_id' });