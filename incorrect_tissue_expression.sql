-- Two UPDATE queries below for changing organs (e.g. brain) of those mice from "tissue not available" to "expression" or "no expression"

-- 1. If at least one subunit (e.g. cerebellum) is "expression", the organ (e.g. brain) should be "expression".
UPDATE laczs SET laczs.brain = 'expression'
WHERE
    (
        laczs.cerebellum LIKE 'expression' OR
        laczs.olfactory_lobe LIKE 'expression' OR
        laczs.midbrain LIKE 'expression' OR
        laczs.forebrain LIKE 'expression' OR
        laczs.hippocampus LIKE 'expression' OR
        laczs.brainstem LIKE 'expression' OR
        laczs.cerebral_cortex LIKE 'expression' OR
        laczs.hypothalamus LIKE 'expression' OR
        laczs.pituitary LIKE 'expression' OR
        laczs.hindbrain LIKE 'expression'
    )
    AND brain = 'tissue not available';


-- 2. If all available subunits (e.g. cerebellum)  are "no expression", the organ (e.g. brain) should be "no expression".
UPDATE laczs SET laczs.brain = 'no expression'
WHERE
    (laczs.cerebellum LIKE 'no expression' OR laczs.cerebellum LIKE 'tissue not available') AND
    (laczs.olfactory_lobe LIKE 'no expression' OR laczs.olfactory_lobe LIKE 'tissue not available') AND
    (laczs.midbrain LIKE 'no expression' OR laczs.midbrain LIKE 'tissue not available') AND
    (laczs.forebrain LIKE 'no expression' OR laczs.forebrain LIKE 'tissue not available') AND
    (laczs.hippocampus LIKE 'no expression' OR laczs.hippocampus LIKE 'tissue not available') AND
    (laczs.brainstem LIKE 'no expression' OR laczs.brainstem LIKE 'tissue not available') AND
    (laczs.cerebral_cortex LIKE 'no expression' OR laczs.cerebral_cortex LIKE 'tissue not available') AND
    (laczs.hypothalamus LIKE 'no expression' OR laczs.hypothalamus LIKE 'tissue not available') AND
    (laczs.pituitary LIKE 'no expression' OR laczs.pituitary LIKE 'tissue not available') AND
    (laczs.hindbrain LIKE 'no expression' OR laczs.hindbrain LIKE 'tissue not available') AND
    CONCAT(
        laczs.cerebellum,
        laczs.olfactory_lobe,
        laczs.midbrain,
        laczs.forebrain,
        laczs.hippocampus,
        laczs.brainstem,
        laczs.cerebral_cortex,
        laczs.hypothalamus,
        laczs.pituitary,
        laczs.hindbrain) !=
    'tissue not availabletissue not availabletissue not availabletissue not availabletissue not availabletissue not availabletissue not availabletissue not availabletissue not availabletissue not available'
    AND brain = 'tissue not available';