BEGIN;

--
-- Create model Amenity
--
CREATE TABLE
    "hotel_amenity" (
        "id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
        "name" varchar(50) NOT NULL UNIQUE,
        "description" text NULL,
        "charge" numeric(7, 2) NOT NULL
    );

--
-- Create model Guest
--
CREATE TABLE
    "hotel_guest" (
        "id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
        "first_name" varchar(50) NOT NULL,
        "last_name" varchar(50) NOT NULL,
        "email" varchar(100) NOT NULL UNIQUE,
        "phone" varchar(20) NULL,
        "created_at" timestamp
        with
            time zone NOT NULL
    );

--
-- Create model Room
--
CREATE TABLE
    "hotel_room" (
        "id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
        "room_number" varchar(10) NOT NULL UNIQUE,
        "floor" integer NOT NULL CHECK ("floor" >= 0),
        "status" varchar(20) NOT NULL
    );

--
-- Create model RoomType
--
CREATE TABLE
    "hotel_roomtype" (
        "id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
        "name" varchar(50) NOT NULL UNIQUE,
        "description" text NULL,
        "capacity" integer NOT NULL CHECK ("capacity" >= 0),
        "rate_per_night" numeric(8, 2) NOT NULL
    );

--
-- Create model Reservation
--
CREATE TABLE
    "hotel_reservation" (
        "id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
        "start_date" date NOT NULL,
        "end_date" date NOT NULL,
        "status" varchar(20) NOT NULL,
        "created_at" timestamp
        with
            time zone NOT NULL,
            "guest_id" bigint NOT NULL,
            "room_id" bigint NOT NULL
    );

--
-- Create model Payment
--
CREATE TABLE
    "hotel_payment" (
        "id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
        "paid_amount" numeric(10, 2) NOT NULL,
        "paid_date" timestamp
        with
            time zone NOT NULL,
            "payment_method" varchar(20) NOT NULL,
            "receipt_number" varchar(50) NOT NULL UNIQUE,
            "reservation_id" bigint NOT NULL
    );

--
-- Add field room_type to room
--
ALTER TABLE "hotel_room"
ADD COLUMN "room_type_id" bigint NOT NULL CONSTRAINT "hotel_room_room_type_id_8d455d55_fk_hotel_roomtype_id" REFERENCES "hotel_roomtype" ("id") DEFERRABLE INITIALLY DEFERRED;

SET
    CONSTRAINTS "hotel_room_room_type_id_8d455d55_fk_hotel_roomtype_id" IMMEDIATE;

--
-- Create model RoomAmenity
--
CREATE TABLE
    "hotel_roomamenity" (
        "id" bigint NOT NULL PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
        "amenity_id" bigint NOT NULL,
        "room_id" bigint NOT NULL
    );

CREATE INDEX "hotel_amenity_name_b4f85d6f_like" ON "hotel_amenity" ("name" varchar_pattern_ops);

CREATE INDEX "hotel_guest_email_155c6e22_like" ON "hotel_guest" ("email" varchar_pattern_ops);

CREATE INDEX "hotel_room_room_number_d330227a_like" ON "hotel_room" ("room_number" varchar_pattern_ops);

CREATE INDEX "hotel_roomtype_name_3736d07f_like" ON "hotel_roomtype" ("name" varchar_pattern_ops);

ALTER TABLE "hotel_reservation" ADD CONSTRAINT "hotel_reservation_guest_id_7a07305e_fk_hotel_guest_id" FOREIGN KEY ("guest_id") REFERENCES "hotel_guest" ("id") DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE "hotel_reservation" ADD CONSTRAINT "hotel_reservation_room_id_da1476cd_fk_hotel_room_id" FOREIGN KEY ("room_id") REFERENCES "hotel_room" ("id") DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX "hotel_reservation_guest_id_7a07305e" ON "hotel_reservation" ("guest_id");

CREATE INDEX "hotel_reservation_room_id_da1476cd" ON "hotel_reservation" ("room_id");

ALTER TABLE "hotel_payment" ADD CONSTRAINT "hotel_payment_reservation_id_c53d77de_fk_hotel_reservation_id" FOREIGN KEY ("reservation_id") REFERENCES "hotel_reservation" ("id") DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX "hotel_payment_receipt_number_4e05b090_like" ON "hotel_payment" ("receipt_number" varchar_pattern_ops);

CREATE INDEX "hotel_payment_reservation_id_c53d77de" ON "hotel_payment" ("reservation_id");

CREATE INDEX "hotel_room_room_type_id_8d455d55" ON "hotel_room" ("room_type_id");

ALTER TABLE "hotel_roomamenity" ADD CONSTRAINT "hotel_roomamenity_room_id_amenity_id_6a5f7ae2_uniq" UNIQUE ("room_id", "amenity_id");

ALTER TABLE "hotel_roomamenity" ADD CONSTRAINT "hotel_roomamenity_amenity_id_4f75ed03_fk_hotel_amenity_id" FOREIGN KEY ("amenity_id") REFERENCES "hotel_amenity" ("id") DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE "hotel_roomamenity" ADD CONSTRAINT "hotel_roomamenity_room_id_77247b94_fk_hotel_room_id" FOREIGN KEY ("room_id") REFERENCES "hotel_room" ("id") DEFERRABLE INITIALLY DEFERRED;

CREATE INDEX "hotel_roomamenity_amenity_id_4f75ed03" ON "hotel_roomamenity" ("amenity_id");

CREATE INDEX "hotel_roomamenity_room_id_77247b94" ON "hotel_roomamenity" ("room_id");

COMMIT;