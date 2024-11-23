package com.example.demo.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table
public class Evento {
    @Id
    private String id;
    @Column
    private String nome;
    @Column
    private String data;
    @Column
    private String hora;
    @Column
    private String palestrante;
    @Column
    private String maxAlunos;
}

