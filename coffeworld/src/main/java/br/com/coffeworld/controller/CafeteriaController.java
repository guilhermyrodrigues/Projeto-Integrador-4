package br.com.coffeworld.controller;

import br.com.coffeworld.model.Cafeteria;
import br.com.coffeworld.service.CafeteriaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/cafeterias")
public class CafeteriaController {

    @Autowired
    private CafeteriaService cafeteriaService;

    @GetMapping(
            produces = {MediaType.APPLICATION_JSON_VALUE}
    )
    public List<Cafeteria> getAllCafeterias() {
        return cafeteriaService.getAllCafeterias();
    }

    @GetMapping(value = "/{id}",
            produces = {MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<Cafeteria> getCafeteriaById(@PathVariable Long id) {
        Optional<Cafeteria> cafeteria = cafeteriaService.getCafeteriaById(id);
        return cafeteria.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping(
            consumes = {MediaType.APPLICATION_JSON_VALUE},
            produces = {MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<Cafeteria> createCafeteria(@RequestBody Cafeteria cafeteria) {
        Cafeteria newCafeteria = cafeteriaService.createCafeteria(cafeteria);
        return new ResponseEntity<>(newCafeteria, HttpStatus.CREATED);
    }

    @PutMapping(
            value = "/{id}",
            consumes = {MediaType.APPLICATION_JSON_VALUE},
            produces = {MediaType.APPLICATION_JSON_VALUE}
    )
    public ResponseEntity<Cafeteria> updateCafeteria(@PathVariable Long id, @RequestBody Cafeteria newCafeteria) {
        Cafeteria updatedCafeteria = cafeteriaService.updateCafeteria(id, newCafeteria);
        return ResponseEntity.ok(updatedCafeteria);
    }

    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> deleteCafeteria(@PathVariable Long id) {
        cafeteriaService.deleteCafeteria(id);
        return ResponseEntity.noContent().build();
    }
}
