package de.illilli.fotopfade.repository;

import de.illilli.fotopfade.model.POI;

import java.util.ArrayList;
import java.util.List;

public class PoiJdbcRepository implements JdbcRepository <POI> {

    @Override
    public List<POI> find() {
        return new ArrayList<>();
    }
}
