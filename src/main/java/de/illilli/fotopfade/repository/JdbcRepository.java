package de.illilli.fotopfade.repository;

import java.util.List;

public interface JdbcRepository<T> {

    List<T> find();

}
