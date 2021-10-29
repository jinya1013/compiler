val sbst_id : Id.t -> Id.t -> Id.t -> Id.t
val sbst_var_name : Id.t -> Id.t -> KNormal.t -> KNormal.t
val h : Id.t -> (Id.t * Type.t) list -> KNormal.t -> KNormal.t
val g : (Id.t * Type.t) list -> KNormal.t -> KNormal.t