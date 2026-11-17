import SwiftUI

// MARK: - 10 · DATOS QUÍMICOS DE MANZANILLA

struct Compound: Identifiable {
    let id: String
    let name: String
    let formula: String
    let family: String
    let mechanism: String
    let extraction: String
}

let compounds: [Compound] = [
    Compound(id: "apigenin", name: "Apigenina", formula: "C₁₅H₁₀O₅", family: "Flavona (flavonoide)", mechanism: "En estudios experimentales se ha asociado con modulación de NF-κB y mediadores inflamatorios. También se ha estudiado su interacción con receptores GABA-A; esto no demuestra por sí solo eficacia clínica contra el insomnio.", extraction: "Los glucósidos de apigenina se recuperan mejor en medios polares como agua y mezclas hidroalcohólicas; la apigenina libre es menos soluble en agua."),
    Compound(id: "apigenin7", name: "Apigenina-7-O-glucósido", formula: "C₂₁H₂₀O₁₀", family: "Flavonoide glucosilado", mechanism: "La unión a una unidad de glucosa modifica la polaridad y la solubilidad respecto de la apigenina libre. La hidrólisis del enlace glucosídico puede liberar apigenina, dependiendo de las condiciones.", extraction: "Se encuentra entre los constituyentes que pueden extraerse de las flores mediante infusión y disolventes polares."),
    Compound(id: "bisabolol", name: "α-Bisabolol", formula: "C₁₅H₂₆O", family: "Alcohol sesquiterpénico", mechanism: "En modelos preclínicos presenta actividad antiinflamatoria; se han investigado cambios en rutas de señalización y producción de mediadores inflamatorios.", extraction: "Componente lipofílico y relativamente volátil del aceite esencial; se recupera principalmente por destilación por arrastre de vapor."),
    Compound(id: "matricin", name: "Matricina", formula: "C₁₇H₂₂O₅", family: "Lactona sesquiterpénica", mechanism: "Es un precursor natural del camazuleno. Durante el procesamiento térmico puede sufrir transformaciones químicas que conducen a camazuleno.", extraction: "Se encuentra en las flores; el calentamiento durante la destilación favorece su transformación, por lo que el perfil del aceite difiere del de la flor."),
    Compound(id: "chamazulene", name: "Camazuleno", formula: "C₁₄H₁₆", family: "Hidrocarburo aromático (azuleno)", mechanism: "Se forma durante la destilación a partir de precursores como la matricina. Se le atribuyen actividades antiinflamatorias en investigación experimental.", extraction: "Característico de ciertos aceites esenciales de manzanilla; no debe suponerse que la infusión contiene la misma cantidad que el aceite destilado.")
]

