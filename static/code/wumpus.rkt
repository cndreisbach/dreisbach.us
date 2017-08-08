#lang racket

;; Instructions on how to play Hunt the Wumpus.
(define *instructions* "
Welcome to Hunt the Wumpus!

The wumpus lives in a cave of 20 rooms. Each room has three tunnels
leading to other rooms. (Look at a dodecahedron to see how this works.
If you don't know what a dodecahedron is, ask someone or get thee to
a Wikipedia.

HAZARDS:
* Bottomless pits - Two rooms have bottomless pits in them. If you go
  there, you fall into the pit (and lose!)
* Super bats - Two other rooms have super bats. If you go there, a bat
  grabs you and take you to some other room at random. (Which might be
  troublesome.)
* The Wumpus - The Wumpus is not bothered by the hazards (he has sucker
  feet and is too big for a bat to lift.) Usually he is asleep. Two
  things wake him up: you entering his room or you shooting an arrow.
  If the wumpus wakes, he moves one room. If you are in the room with
  him, he might stay still (1/4 of the time.) After that, if he is where
  you are, he eats you up (and you lose!)

YOU:
Each turn you may move or shoot a crooked arrow.

* Moving: You can go one room (through one tunnel.)
* Shooting: Each arrow can go 1 to 5 rooms. You aim by telling the 
  computer the rooms you want the arrow to go to. If the arrow hits the 
  Wumpus, you win. If the arrow misses the Wumpus, it moves.

WARNINGS:
When you are one room away from a hazard, the computer says:

* Wumpus: 'I smell a wumpus'
* Bat: 'Bats nearby'
* Pit: 'I feel a draft'
")

;;; Utility functions

;; Instead of referencing into different data structures with different
;; methods, we create a method "->" to polymorphically reference into
;; data structures.
(define (-> coll key)
  (cond
    [(list? coll) (list-ref coll key)]
    [(vector? coll) (vector-ref coll key)]
    [(hash? coll) (hash-ref coll key)]
    [else key]))

;; Combine two lists into a list of dotted pairs. This allows us to
;; create a hash using make-hash, which we require so that it is
;; mutable. The function "hash" only creates immutable hashes.
(define (zip p q) 
  (map (lambda (p q) (cons p q)) p q))

;;; Game functions

;; Begins the game.
(define (hunt-the-wumpus)
  (let [(locations (create-locations))]
    (display "Hunt the Wumpus!\n")
    (display-instructions)
    (take-turn locations)))

;; Ask the user if they need instructions. Even though we only have one
;; clause in our case statement, we use one because it's much less verbose
;; than checking the user's choice against two possibilities.
(define (display-instructions)
  (display "Do you need instructions? [y/n] ")
  (let ((choice (read)))
    (case choice
      ((\Y \y) (display *instructions*)
               (display "\n\n\n")))))

;; Create a mutable hash of locations we will use to manage the state of 
;; the game. The use of an optional argument to this function makes
;; recursion easier.
(define (create-locations [locations '()])
  (if (= 6 (length locations))
      (make-hash 
       (zip
        '(player wumpus pits bats)
        (list (car locations)
              (cadr locations)
              (list (-> locations 2) (-> locations 3))
              (list (-> locations 4) (-> locations 5)))))
      (create-locations (add-location locations))))

;; Add a new location to the list. We do not want the same location twice
;; so we eliminate duplicates here. For a larger list, this would be
;; unsustainable, but for a small list, this is easier than bringing in
;; sets and converting back and forth.
(define (add-location locations)
  (let ((new-loc (random 20)))
    (if (member new-loc locations)
        locations
        (cons new-loc locations))))

;; The main logic of the game. This is where we determine the next
;; action to take and detect game end. While most conditions are 
;; preemptive of each other, wumpus detection happens independently.
;; When the wumpus is in the same room as the player, it may leave
;; the room or stay. We need to know what the wumpus does before we
;; can check for player death.
(define (take-turn locations)
  (let [(player-room (-> locations 'player))]    
    (check-for-wumpus player-room locations)
    (cond
      [(check-for-bats player-room locations)
       (display "You have been grabbed by super-bats and whisked to another room!\n")
       (hash-set! locations 'player (random 20))
       ;; Start turn over, since you're in a new room.
       (take-turn locations)]
      [(check-for-win locations)
       (display "Congratulations!\n")]
      [(check-for-death player-room locations)
       (display "You are dead!\n")]
      [else
       (display-room player-room locations)
       (choose-shoot-or-move player-room locations)
       (take-turn locations)])))

;; Check to see if the player is in a room with bats.
(define (check-for-bats player-room locations)
  (member player-room (-> locations 'bats)))

;; Check to see if the player's in the same room with the wumpus.
;; If so, the wumpus either moves to an adjacent room (3/4 of the time)
;; or stays in the room to eat the player.
(define (check-for-wumpus player-room locations)
  (cond 
    ;; If the wumpus is dead, its location will be null.
    ;; A null location can't be =ed to a number, therefore
    ;; we check first.
    [(and (not (null? (-> locations 'wumpus)))
          (= player-room (-> locations 'wumpus)))
     (display "You bumped a wumpus!\n")
     (let ((choice (random 4)))
       (cond 
         [(< choice 3)
          (display "The wumpus hurries off.\n")        
          (move-wumpus locations (-> (nearby-rooms player-room) choice))]))]))

;; If we don't specify where to move the wumpus, it moves in a random
;; direction. The wumpus moves when the player shoots an arrow and 
;; misses it, or (possibly) when the player moves into the room with it.
(define (move-wumpus locations [new-location #f])
  (if new-location
      (hash-set! locations 'wumpus new-location)
      (move-wumpus locations 
                   (-> (nearby-rooms (-> locations 'wumpus)) 
                       (random 3)))))

;; If the player is in the same room as a pit or the wumpus when we 
;; check for death, then the player is dead. We explicitly return #t or
;; #f here, which I'm not a big fan of.
(define (check-for-death player-room locations)
  (cond
    [(= player-room (-> locations 'wumpus))
     (display "The wumpus ate you!\n")
     #t]
    [(member player-room (-> locations 'pits))
     (display "Ayeeee! You fell in a pit!\n")
     #t]
    [else #f]))

;; If the wumpus is dead, its location will be null, and the player wins!
(define (check-for-win locations)
  (null? (-> locations 'wumpus)))

;; Show the player information about the current room.
(define (display-room room locations)
  (let [(nearby-rooms (nearby-rooms room))]
    (display (format "You are in room ~a.~n" room))
    (display-nearby-tunnels nearby-rooms)
    (display-nearby-danger nearby-rooms locations)))

;; Look up nearby rooms in the cavern map.
(define (nearby-rooms room)
  (-> *map* room))

;; Displays warnings about nearby danger to the player.
;; Note the use of ormap, a really interesting function.
(define (display-nearby-danger nearby-rooms locations)
  (cond
    [(member (-> locations 'wumpus) nearby-rooms)
     (display "I smell a wumpus!\n")]
    [(ormap (lambda (l) (member l nearby-rooms)) (-> locations 'pits))
     (display "I feel a draft.\n")]
    [(ormap (lambda (l) (member l nearby-rooms)) (-> locations 'bats))
     (display "Bats nearby!\n")]))

;; Displays the nearby rooms to the player.
(define (display-nearby-tunnels nearby-rooms)
  (display (apply format "Tunnels lead to ~a, ~a, and ~a.~n" nearby-rooms)))

;; Ask the player whether they would like to shoot or move.
(define (choose-shoot-or-move room locations)
  (display "(S)hoot or (M)ove? ")
  (let [(choice (read))]
    (case choice
      ((\S \s) (shoot-arrow room locations))
      ((\M \m) (choose-room-to-move room locations))
      (else (display "Invalid input!\n")
            (choose-shoot-or-move room locations)))))

;; Ask the player what room they would like to move to.
(define (choose-room-to-move from-room locations)
  (display "Move to room: ")
  (let [(choice (read))
        (nearby-rooms (nearby-rooms from-room))]
    (if (member choice nearby-rooms)
        (move-to-room choice locations)
        (begin (display "You cannot go there!\n")
               (choose-room-to-move from-room locations)))))

;; Move the player to a new room.
(define (move-to-room room locations)
  (hash-set! locations 'player room))

;; Ask the player how many rooms they would like to shoot through.
(define (shoot-arrow from-room locations)
  (display "How many rooms to shoot through? ")
  (let ((choice (read)))
    (cond
      [(and (> choice 0) (<= choice 5))
       (choose-rooms-to-shoot from-room locations choice)]
      [else (display "You can't shoot through that many rooms!\n")
            (shoot-arrow from-room locations)])))

;; Ask the player what rooms they would like to shoot through. Recurse
;; until they've shot through as many rooms as they specified.
(define (choose-rooms-to-shoot from-room locations num-left)
  (if (= num-left 0)
      (detect-wumpus-shooting from-room locations)
      (let ((available-rooms (nearby-rooms from-room)))      
        (display (apply format "You can shoot into ~a, ~a, or ~a.~n" available-rooms))
        (display "Which room to shoot into? ")
        (let ((choice (read)))
          (if (member choice available-rooms)
              (choose-rooms-to-shoot choice locations (sub1 num-left))
              (begin
                (display "You can't shoot into there!\n")
                (choose-rooms-to-shoot from-room locations num-left)))))))

;; Detect whether the player shot the wumpus. If they missed, move the
;; wumpus. Otherwise, mark the wumpus as dead.
(define (detect-wumpus-shooting room locations)
  (cond
    [(= room (-> locations 'wumpus))
     (display "You shot the wumpus!\n")
     (hash-set! locations 'wumpus null)]
    [else
     (display "You missed the wumpus! He's on the move.\n")
     (move-wumpus locations)]))

;; The map is a vector of lists. The number of each room is the index
;; to look it up in the vector.
(define *map* #((1 4 7)
                (0 2 9)
                (1 3 11)
                (2 4 13)
                (0 3 5)
                (4 6 14)
                (5 7 16)
                (0 6 8)
                (7 9 17)
                (1 8 10)
                (9 11 18)
                (2 10 12)
                (11 13 19)
                (3 12 14)
                (5 13 15)
                (14 16 19)
                (6 15 17)
                (8 16 18)
                (10 17 19)
                (12 15 18)))
