;;!pre-parsing:{type: "nunjucks", data: "data.json"}

; hints: https://mozilla.github.io/nunjucks/templating.html

(define (problem {{data.username}})

(:domain hello)

(:objects

    {% for r in range(1, data.rooms+1) %}
    room{{r}} - room
    {%endfor%}
    {% for l in range(1, data.mixers+1) %}
    mixer{{l}} - mixer
    {%endfor%}

    layer1 - layer
)

(:init

    (available room1)
    (available room2)
    (ready john)
    {% for rhyme in data.time_mix %}
    (= (time_mix layer{{loop.index}}) {{rhyme}})
    {%endfor%}

)

(:goal
    (and
        (paintready room1)
        ; (painted room1)
        ; (painted room2)
    )
)
)