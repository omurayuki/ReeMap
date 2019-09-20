import Foundation

struct MapsTranslator {
    
    func translate(_ entities: [PlaceEntity]) -> [Place] {
        return entities.map { MapTranslator().translate($0) }
    }
}

fileprivate struct MapTranslator {
    
    func translate(_ entity: PlaceEntity) -> Place {
        return Place(entity: entity)
    }
}
