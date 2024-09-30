package br.com.coffeworld.service;

import br.com.coffeworld.model.Cafeteria;
import br.com.coffeworld.repository.CafeteriaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CafeteriaService {

    @Autowired
    private CafeteriaRepository cafeteriaRepository;

    public List<Cafeteria> getAllCafeterias() {
        return cafeteriaRepository.findAll();
    }

    public Optional<Cafeteria> getCafeteriaById(Long id) {
        return cafeteriaRepository.findById(id);
    }

    public Cafeteria createCafeteria(Cafeteria cafeteria) {
        return cafeteriaRepository.save(cafeteria);
    }

    public Cafeteria updateCafeteria(Long id, Cafeteria newCafeteria) {
        return cafeteriaRepository.findById(id)
                .map(cafeteria -> {
                    cafeteria.setNome(newCafeteria.getNome());
                    cafeteria.setEndereco(newCafeteria.getEndereco());
                    cafeteria.setImagem(newCafeteria.getImagem());
                    cafeteria.setContato(newCafeteria.getContato());
                    return cafeteriaRepository.save(cafeteria);
                })
                .orElseGet(() -> {
                    newCafeteria.setId(id);
                    return cafeteriaRepository.save(newCafeteria);
                });
    }

    public void deleteCafeteria(Long id) {
        cafeteriaRepository.deleteById(id);
    }
}
