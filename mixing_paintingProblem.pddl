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

    ; todo: replace by a nunjucks for loop
    layer1 - layer
    layer2 - layer
    layer3 - layer
    layer4 - layer
    layer5 - layer
    layer6 - layer

    ; todo: replace by a loop from data.json
    john - mixer
)

(:init

    ; todo: replace by a loop from data.json
    (available room1)
    (available room2)

    ; todo: replace by a loop from data.json
    (ready john)
    {% for rhyme in data.time_mix %}
    (= (time_mix layer{{loop.index}}) {{rhyme}})
    {%endfor%}

)

(:goal
    (and

        ; todo: generate goals from data.json
        (painted room1)
        (painted room2)
    )
)
)