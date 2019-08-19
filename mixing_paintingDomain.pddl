(define (domain painting)

(:requirements :strips :typing :negative-preconditions :fluents :durative-actions)

(:types room layer mixer)

(:predicates
    (paintready ?r - room ?l - layer) ; paint is ready for the room `?r` and layer `?l`
    (paintwaiting ?r - room) ; paint is waiting in the room `?r` and therefore further mixing cannot start
    (available ?r - room) ; room `?r` is available for mixing or painting 
    (painted ?r - room ?l - layer) ; this is the goal: the room should have the layer painted
    (ready ?m - mixer) ; paint mixer `?m` is available for mixing
    (painting) ; Keeps track of the state of the painter
    (painters_in ?r - room) ; painters are in the room `?r`
    (disposable_brush) ; The brush self cleans imediately while switching rooms
    
    ; Layers must be painted in the order 1..M
    (current ?l - layer ?r - room) ; current layer to be mixed/painted
    (next_layer ?l1 ?l2 - layer) ; sequence of layers
)

(:functions
    (time_mix ?l - layer) ; Time to mix the paint for layer `?l`
    (time_paint ?l - layer) ; Time to paint layer `?l`
    (time_clean) ; Time to clean the brush
)

; Paints layer `?l` in room `?r`
(:durative-action paint
    :parameters (?r - room ?l - layer)
    :duration (= ?duration (time_paint ?l))
    :condition (and
        (at start(and
            (available ?r)
            (not (painted ?r ?l))
            (paintready ?r ?l)
            (not(painting))
            (painters_in ?r)
        ))
    )
    :effect (and
        (at start (and
            (not(available ?r))
            (painting)
            (not (paintwaiting ?r))
        ))
        (at end (and
            (painted ?r ?l)
            (available ?r)
            (not (paintready ?r ?l))
            (not (painting))
        ))

    )
)

; Mixes paint for layer `?l` in room `?r` using mixer `?m`.
(:durative-action mix
    :parameters (?r - room ?m - mixer ?l - layer)
    :duration (= ?duration (time_mix ?l))
    :condition (and 
        (at start (and 
            (available ?r)
            ; paint for the previous layer was consumed
            (not (paintwaiting ?r))
            (not (paintready ?r ?l))
            (ready ?m)
            (current ?l ?r)
        ))
    )
    :effect (and 
        (at start (and 
            (not(available ?r))
            (not (ready ?m))
        ))
        (at end (and 
            (ready ?m)
            (paintready ?r ?l)
            (paintwaiting ?r)
            (available ?r)
        ))
    )
)

; Clean the (non-disposable) brush as the painters move from `?r1` to `?r2`.
(:durative-action clean
    :parameters (?r1 ?r2 - room)
    :duration (= ?duration (time_clean))
    :condition (and 
        (at start (and 
            (painters_in ?r1)
            ; only consider this when the brush is not disposable
            (not (disposable_brush))
        ))
        (over all (and
            (not (painting))
        ))
    )
    :effect (and 
        (at start (and 
            (not (painters_in ?r1))
        ))
        (at end (and 
            (painters_in ?r2)
        ))
    )
)


; Disposes the brush and gets a clean one, while switching between rooms
(:action _dispose_brush
    :parameters (?r1 ?r2 - room)
    :precondition (and 
        (not (painting))
        (painters_in ?r1)
        (disposable_brush)
    )
    :effect (and 
        (not (painters_in ?r1))
        (painters_in ?r2)
    )
)

; Moves to the next layer
(:action _next_layer
    :parameters (?l1 ?l2 - layer ?r - room)
    :precondition (and 
        (painted ?r ?l1)
        (current ?l1 ?r)
        (next_layer ?l1 ?l2)
    )
    :effect (and 
        (not (current ?l1 ?r))
        (current ?l2 ?r)
    )
)


)