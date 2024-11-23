package com.example.demo.controller;

import com.example.demo.exception.BadRequestException;
import com.example.demo.exception.ConflictException;
import com.example.demo.model.Evento;
import com.example.demo.repository.EventoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@CrossOrigin
@RestController
@RequestMapping("/apiEvento")
public class EventoController {

    @Autowired
    EventoRepository eventoRepo;

    @GetMapping("/findall")
    public List<Evento> findAll () {
        return eventoRepo.findAll();
    }

    @PostMapping("/insert")
    public Evento inserir (@RequestBody Evento evento)
    {
        if(eventoRepo.existsById(evento.getId())) {
            throw new ConflictException("id já existente");
        }
        return eventoRepo.save(evento);
    }

    @PutMapping ("/update/{id}")
    public Evento update (@RequestBody Evento evento, @PathVariable("id") String id)
    {
        if(!eventoRepo.existsById(evento.getId())) {
            throw new BadRequestException("id não encontrada");
        }
        return eventoRepo.save(evento);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity delete (@PathVariable("id") String id)
    {
        if(!eventoRepo.existsById(id)) {
            throw new BadRequestException("id não encontrada");
        }
        eventoRepo.deleteById(id);
        return ResponseEntity.ok("evento deletado");
    }
}
