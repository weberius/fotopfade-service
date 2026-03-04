package de.illilli.fotopfade.services;

import de.illilli.fotopfade.model.Gallery;
import de.illilli.fotopfade.model.POI;
import de.illilli.fotopfade.repository.JdbcRepository;
import de.illilli.fotopfade.repository.PoiValuesRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

public class GalleryService {

    private static Logger logger = LoggerFactory.getLogger(GalleryService.class);

    private List<Gallery> galleries = new ArrayList<>();
    private JdbcRepository<POI> repo = new PoiValuesRepository("");

    public GalleryService(String id) {
        // 1. get Data
        repo = new PoiValuesRepository(id);
        List<POI> beans = repo.find();
        // 2. Map to GeoJson
        int i = 1;
        for (POI poi : beans) {
            String name = poi.getName();
            IdParser parser = new IdParser(poi.getId());
            Gallery gallery = new Gallery();
            gallery.setTitle(name);
            //images/frankenberg/p1.jpg
            String href = "images/" + id + "/p" + parser.getId() + ".jpg";
            gallery.setHref(href);
            if ("p".equals(parser.getPoint()) || "u".equals(parser.getPoint()) || "o".equals(parser.getPoint())) {
                galleries.add(gallery);
            }
        }
    }

    public List<Gallery> getList() {
            return galleries;
    }

}
