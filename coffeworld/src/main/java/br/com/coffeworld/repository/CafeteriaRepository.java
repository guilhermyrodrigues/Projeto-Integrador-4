package br.com.coffeworld.repository;

import br.com.coffeworld.model.Cafeteria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CafeteriaRepository extends JpaRepository<Cafeteria, Long> {
}
