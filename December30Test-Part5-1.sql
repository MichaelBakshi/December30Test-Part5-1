PGDMP     6    *                 y            December30Part5db    13.1    13.1 !    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16593    December30Part5db    DATABASE     o   CREATE DATABASE "December30Part5db" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Hebrew_Israel.1252';
 #   DROP DATABASE "December30Part5db";
                postgres    false            �            1255    16674 "   another_update_salary_by_role_id() 	   PROCEDURE     �   CREATE PROCEDURE public.another_update_salary_by_role_id()
    LANGUAGE plpgsql
    AS $$
    begin
        update workers
            set  salary = 20
        where role_id=1;
    end;
    $$;
 :   DROP PROCEDURE public.another_update_salary_by_role_id();
       public          postgres    false            �            1255    16677    avg_salary_by_role(bigint)    FUNCTION     A  CREATE FUNCTION public.avg_salary_by_role(_role_id bigint) RETURNS TABLE(avg_salary bigint)
    LANGUAGE plpgsql
    AS $$

    begin
        return query
     select (t1.total_salary)/ (t1.total_number_of_workers) as average_salary from
            (SELECT  sum(w.salary) as total_salary, count(w.id) as total_number_of_workers, r.name FROM workers w
            join roles r on w.role_id = r.id
            where w.role_id=_role_id
            group by r.name,w.role_id)t1;
            --order by w.site_id
             --group by  t1.site_name;
    end;
    $$;
 :   DROP FUNCTION public.avg_salary_by_role(_role_id bigint);
       public          postgres    false            �            1255    16667 *   get_all_workers_from_specific_site(bigint)    FUNCTION     �   CREATE FUNCTION public.get_all_workers_from_specific_site(site_id bigint) RETURNS TABLE(worker_name text)
    LANGUAGE plpgsql
    AS $$
begin
        return query
    select w.name from workers w
    join sites on w.site_id = sites.id;
end;
$$;
 I   DROP FUNCTION public.get_all_workers_from_specific_site(site_id bigint);
       public          postgres    false            �            1255    16663    get_all_workers_info()    FUNCTION     {  CREATE FUNCTION public.get_all_workers_info() RETURNS TABLE(id bigint, name text, phone text, salary integer, role_id bigint, site_id bigint, role_name text)
    LANGUAGE plpgsql
    AS $$
    begin
        return query
     SELECT w.id,w.name, w.phone, w.salary, w.role_id, w.site_id , r.name  FROM workers w
            join roles r on w.role_id = r.id;
    end;
    $$;
 -   DROP FUNCTION public.get_all_workers_info();
       public          postgres    false            �            1255    16665    get_site_with_max_workers()    FUNCTION     �  CREATE FUNCTION public.get_site_with_max_workers() RETURNS TABLE(number_of_workers bigint, site_name text)
    LANGUAGE plpgsql
    AS $$
    begin
        return query
     SELECT  count(w.site_id) as number_of_workers, s.name as site_name FROM workers w
            join sites s on w.site_id = s.id
            group by w.site_id,s.name
            order by w.site_id
            limit 1;
    end;
    $$;
 2   DROP FUNCTION public.get_site_with_max_workers();
       public          postgres    false            �            1255    16759     update_salary_by_role_id(bigint) 	   PROCEDURE     �  CREATE PROCEDURE public.update_salary_by_role_id(_role_id bigint)
    LANGUAGE plpgsql
    AS $$
    begin
        if (_role_id=1)
        then
        update workers
            set  salary = 20
        where workers.role_id=_role_id;
        else
            update workers set salary = (random ()*5000)::int+5000
            where workers.role_id>=_role_id;
        end if;
    end;
    $$;
 A   DROP PROCEDURE public.update_salary_by_role_id(_role_id bigint);
       public          postgres    false            �            1259    16618    roles    TABLE     E   CREATE TABLE public.roles (
    id bigint NOT NULL,
    name text
);
    DROP TABLE public.roles;
       public         heap    postgres    false            �            1259    16652    roles_id_seq    SEQUENCE     u   CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    200            �           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          postgres    false    203            �            1259    16626    sites    TABLE     W   CREATE TABLE public.sites (
    id bigint NOT NULL,
    name text,
    address text
);
    DROP TABLE public.sites;
       public         heap    postgres    false            �            1259    16655    sites_id_seq    SEQUENCE     u   CREATE SEQUENCE public.sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sites_id_seq;
       public          postgres    false    201            �           0    0    sites_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sites_id_seq OWNED BY public.sites.id;
          public          postgres    false    204            �            1259    16634    workers    TABLE     �   CREATE TABLE public.workers (
    id bigint NOT NULL,
    name text,
    phone text,
    salary integer,
    role_id bigint,
    site_id bigint
);
    DROP TABLE public.workers;
       public         heap    postgres    false            �            1259    16658    workers_id_seq    SEQUENCE     w   CREATE SEQUENCE public.workers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.workers_id_seq;
       public          postgres    false    202            �           0    0    workers_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.workers_id_seq OWNED BY public.workers.id;
          public          postgres    false    205            7           2604    16654    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    200            8           2604    16657    sites id    DEFAULT     d   ALTER TABLE ONLY public.sites ALTER COLUMN id SET DEFAULT nextval('public.sites_id_seq'::regclass);
 7   ALTER TABLE public.sites ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    204    201            9           2604    16660 
   workers id    DEFAULT     h   ALTER TABLE ONLY public.workers ALTER COLUMN id SET DEFAULT nextval('public.workers_id_seq'::regclass);
 9   ALTER TABLE public.workers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    202            �          0    16618    roles 
   TABLE DATA           )   COPY public.roles (id, name) FROM stdin;
    public          postgres    false    200   �(       �          0    16626    sites 
   TABLE DATA           2   COPY public.sites (id, name, address) FROM stdin;
    public          postgres    false    201   �(       �          0    16634    workers 
   TABLE DATA           L   COPY public.workers (id, name, phone, salary, role_id, site_id) FROM stdin;
    public          postgres    false    202   b)       �           0    0    roles_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.roles_id_seq', 5, true);
          public          postgres    false    203            �           0    0    sites_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sites_id_seq', 5, true);
          public          postgres    false    204            �           0    0    workers_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.workers_id_seq', 5, true);
          public          postgres    false    205            ;           2606    16625    roles roles_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    200            =           2606    16633    sites sites_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.sites DROP CONSTRAINT sites_pkey;
       public            postgres    false    201            ?           2606    16641    workers workers_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.workers DROP CONSTRAINT workers_pkey;
       public            postgres    false    202            @           2606    16642    workers workers_role_id_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);
 F   ALTER TABLE ONLY public.workers DROP CONSTRAINT workers_role_id_fkey;
       public          postgres    false    2875    200    202            A           2606    16647    workers workers_site_id_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id);
 F   ALTER TABLE ONLY public.workers DROP CONSTRAINT workers_site_id_fkey;
       public          postgres    false    2877    202    201            �   C   x�3�LN,*H�+I-�2�LIM�/J,�/�2�,O�I
�p��&Y���9��%E�ə�y\1z\\\ ��      �   h   x��K�0Eѱ�
��R?��<�@bK6����{t來R���2�� LR��Fۢ!#t����&M7Ё����V�R����+�6t�h 0�����)��3��&C      �   `   x�%�1
�0@���0Ŗ�`_!��C�.%	��r�Z��=e~-o��SB1q��E�@�>`��+�ּ*��dh"�,����oC�wy�D�4<9     