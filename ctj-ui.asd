(asdf:defsystem #:ctj-ui
  :name "Chess: The Journey UI"
  :depends-on (:ctj :clog :spinneret :alexandria :serapeum :str :queen)
  :pathname "src/"
  :serial t
  :components
  ((:file "package")
   (:file "main")
   (:file "main-menu")
   (:file "game-menu")
   (:file "mail-inbox")
   (:file "player-table")
   (:file "chess-game")
   (:file "tournament-table")))