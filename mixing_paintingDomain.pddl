(define (domain hello)

(:requirements :strips :typing :negative-preconditions :fluents :durative-actions)

(:types room layer mixer)

(:predicates
    (paintready ?r - room ?l - layer)
    (available ?r - room)
    (painted ?r - room ?l - layer)
    (ready ?m - mixer)
    (painting)
)

(:functions
    (time_mix ?l - layer)
    (time_paint ?l - layer)
)

; todo: turn this into a durative-action with a proper duration
(:durative-action paint
    :parameters (?r - room ?l - layer)
    :duration (= ?duration (time_paint ?l))
    :condition (and
        (at start(and
            (available ?r)
            (not (painted ?r ?l))
            (paintready ?r ?l)
            (not(painting))
        ))
    )
    :effect (and
        (at start (and
            (not(available ?r))
            (painting)
        ))
        (at end (and
            (painted ?r ?l)
            (available ?r)
            (not (paintready ?r ?l))
            (not(painting))
        ))

    )
)


(:durative-action mix
    :parameters (?r - room ?m - mixer ?l - layer)
    :duration (= ?duration (time_mix ?l))
    :condition (and 
        (at start (and 
            (available ?r)
            (not (paintready ?r ?l))
            (ready ?m)
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
            (available ?r)
        ))
    )
))