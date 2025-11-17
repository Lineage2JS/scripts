SET client_encoding = 'UTF8';

CREATE TABLE public.accounts (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    login character varying NOT NULL,
    password character varying NOT NULL,
    access_level integer DEFAULT 0
);

CREATE TABLE public.characters (
    object_id integer PRIMARY KEY,
    user_login character varying(30) NOT NULL,
    character_name character varying(30) NOT NULL,
    title character varying NOT NULL,
    level integer NOT NULL,
    gender integer NOT NULL,
    hair_style integer NOT NULL,
    hair_color integer NOT NULL,
    face integer NOT NULL,
    heading integer NOT NULL,
    access_level integer NOT NULL,
    online boolean DEFAULT false NOT NULL,
    online_time integer NOT NULL,
    is_gm boolean NOT NULL,
    exp integer NOT NULL,
    sp integer NOT NULL,
    pvp integer NOT NULL,
    pk integer NOT NULL,
    karma integer NOT NULL,
    class_id integer NOT NULL,
    class_name character varying NOT NULL,
    race_id integer NOT NULL,
    str integer NOT NULL,
    dex integer NOT NULL,
    con integer NOT NULL,
    "int" integer NOT NULL,
    wit integer NOT NULL,
    men integer NOT NULL,
    current_hp integer NOT NULL,
    max_hp integer NOT NULL,
    current_mp integer NOT NULL,
    max_mp integer NOT NULL,
    base_run_speed integer NOT NULL,
    base_walk_speed integer NOT NULL,
    x integer NOT NULL,
    y integer NOT NULL,
    z integer NOT NULL,
    attack_speed_multiplier numeric NOT NULL,
    collision_radius numeric NOT NULL,
    collision_height numeric NOT NULL,
    created_at timestamp without time zone NOT NULL
);

CREATE TABLE public.gameservers (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gameserver_id integer NOT NULL,
    host character varying(20) NOT NULL,
    port integer NOT NULL,
    age_limit integer DEFAULT 0 NOT NULL,
    is_pvp boolean DEFAULT false NOT NULL,
    max_players integer DEFAULT 100 NOT NULL,
    server_status integer DEFAULT 0 NOT NULL,
    server_type integer DEFAULT 1 NOT NULL
);

CREATE TABLE public.items (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    object_id integer NOT NULL,
    item_id integer NOT NULL,
    item_count integer NOT NULL,
    location character varying(100) NOT NULL,
    owner_object_id integer NOT NULL,
    equip_slot integer
);

CREATE TABLE public.object_id_registry (
    registry_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    registry_name character varying NOT NULL,
    last_object_id integer NOT NULL
);

CREATE TABLE public.scheduled_tasks (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type character varying,
    payload json,
    scheduled_at timestamp without time zone,
    status character varying,
    created_account_id character varying,
    created_type character varying
);

CREATE TABLE public.skills (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    skill_id integer NOT NULL,
    skill_level integer NOT NULL,
    owner_object_id integer NOT NULL
);

INSERT INTO public.object_id_registry (registry_name, last_object_id) VALUES ('world', 1);