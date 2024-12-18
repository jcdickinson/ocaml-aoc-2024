(lang dune 3.16)

(name learn)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name learn)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune sexplib ppx_deriving core interval)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
