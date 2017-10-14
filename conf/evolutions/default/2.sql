# --- !Ups
ALTER TABLE dummy ADD(
    deleted_at datetime not null
);

# --- !Downs
ALTER TABLE dummy DROP(
    deleted_at
);