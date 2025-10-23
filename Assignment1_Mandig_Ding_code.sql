-- Pre-Step: Check Avaible 'vocabulary_id' in `bigquery-public-data.cms_synthetic_patient_data_omop.concept`
-- They're 'CPT4','ICD10CM','ICD9CM','LOINC','NDC','NDFRT','RxNorm','RxNorm Extension','SNOMED','SPL


-- Created codebook session. 
-- Include HIV-related condition in ICD9CM, ICD10CM and SNOMED codes. 
WITH hiv_codes AS (
  SELECT
    cs.concept_id AS source_concept_id,
    cs.concept_code AS icd_code,
    cs.concept_name AS icd_name,
    ct.concept_id AS standard_concept_id,
    ct.concept_code AS snomed_code,
    ct.concept_name AS snomed_name,
    ct.valid_start_date AS valid_start_date,
    ct.valid_end_date AS valid_end_date,
  FROM
    `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS cs
    JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.concept_relationship` AS cr ON cr.concept_id_1 = cs.concept_id
    JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS ct ON ct.concept_id = cr.concept_id_2
  WHERE
    (
      (cs.vocabulary_id = "ICD10CM")
      AND (
        (cs.concept_code LIKE "B20%")
        OR (cs.concept_code LIKE "Z21%")
        OR (cs.concept_code LIKE "O98%")
      )
    )
    OR (
      (cs.vocabulary_id = "ICD9CM")
      AND (cs.concept_code LIKE "042%")
    )
    OR ((cs.vocabulary_id = "SNOMED"))
    AND (
      cs.concept_code IN (
        '79019005',
        '78466009',
        '86406008',
        '1054001000000101',
        '1053901000000104',
        '1003680007',
        '1004006009',
        '1052325005',
        '1142045004',
        '1142046003',
        '1142049005',
        '1142055000',
        '1148863007',
        '235921000112100',
        '1287783000',
        '550891000000106',
        '577001000000106',
        '664701000000103',
        '1721000124106',
        '838338001',
        '838377003',
        '840442003',
        '840498003',
        '860871003',
        '860872005',
        '860874006',
        '866044006',
        '870344006',
        '870328002',
        '870271009',
        '230201009',
        '230180003',
        '230598008',
        '186706006',
        '186707002',
        '186709004',
        '186715004',
        '186708007',
        '186714000',
        '235009000',
        '431347008',
        '398329009',
        '276666007',
        '52079000',
        '315019000',
        '313077009',
        '405631006',
        '91948008',
        '91947003',
        '40780007',
        '397763006',
        '235726002',
        '240103002',
        '1086401000000106',
        '1086721000000106',
        '1086731000000108',
        '1087061000000102',
        '1087081000000106',
        '1087221000000100',
        '15928141000119107',
        '719522009',
        '719789000',
        '721166000',
        '722554000',
        '722557007',
        '713260006',
        '713275003',
        '713297001',
        '713298006',
        '713300006',
        '713316008',
        '713318009',
        '713325002',
        '713339002',
        '713340000',
        '713341001',
        '713349004',
        '713444005',
        '713446007',
        '713483007',
        '713484001',
        '713487008',
        '713488003',
        '713490002',
        '713491003',
        '713497004',
        '713503007',
        '713504001',
        '713505000',
        '713506004',
        '713507008',
        '713510001',
        '713511002',
        '713523008',
        '713526000',
        '713527009',
        '713530002',
        '713531003',
        '713532005',
        '713533000',
        '713543002',
        '713545009',
        '713546005',
        '713570009',
        '713571008',
        '713572001',
        '713695001',
        '713696000',
        '713718006',
        '713722001',
        '713729005',
        '713730000',
        '713731001',
        '713732008',
        '713733003',
        '713745007',
        '713844000',
        '713845004',
        '713880000',
        '713881001',
        '713887002',
        '713897006',
        '713964006',
        '713967004',
        '714464009',
        '713299003',
        '713320007',
        '713489006',
        '714083007',
        '713734009',
        '713278001',
        '713342008',
        '713445006',
        '713508003',
        '713544008',
        '733834006',
        '733835007',
        '1187000005',
        '1187001009',
        '1187156006',
        '1193751008',
        '1193752001',
        '1263535005',
        '143487009',
        '166119007',
        '186727001',
        '187438009',
        '187453001',
        '240612001',
        '442134007',
        '442537007',
        '442662004',
        '735521001',
        '735522008',
        '735523003',
        '735524009',
        '735526006',
        '735527002',
        '735528007',
        '737378009',
        '737379001',
        '737380003',
        '737381004',
        '90681000119107',
        '90691000119105',
        '735525005',
        '473233007',
        '473382005',
        '81000119104',
        '200901000000108',
        '248981000000107',
        '439901000000106',
        '468931000000102',
        '835401000000109',
        '862341000000100',
        '10755671000119100',
        '705149003',
        '72621000119104',
        '76981000119106',
        '76991000119109',
        '80191000119101',
        '129261000119106',
        '72631000119101',
        '943041000000105'
      )
      AND (
        (
          ct.valid_start_date <= DATE('2008-01-01')
          OR ct.valid_start_date IS NULL
        )
        AND (
          ct.valid_end_date >= DATE('2010-12-31')
          OR ct.valid_end_date IS NULL
        )
      )
    )
),

-- Create medication: Atripla code and its ingredient in RxNorm, RxNorm Extension and SPL codes
Atripla_codes AS (
  SELECT
    cs.concept_id AS source_concept_id,
    cs.concept_code AS icd_code,
    cs.concept_name AS icd_name,
    ct.concept_id AS standard_concept_id,
    ct.concept_code AS snomed_code,
    ct.concept_name AS snomed_name,
    ct.valid_start_date AS valid_start_date,
    ct.valid_end_date AS valid_end_date,
  FROM
    `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS cs
    JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.concept_relationship` AS cr ON cr.concept_id_1 = cs.concept_id
    JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS ct ON ct.concept_id = cr.concept_id_2
  WHERE
    (
      (cs.vocabulary_id = "RxNorm")
      AND (
        cs.concept_code IN ('561401', '613228', '613229', '613230')
      )
    )
    OR (
      (cs.vocabulary_id = "SPL")
      AND (
        cs.concept_code IN (
          'c911bcbf-7ffb-4366-9fe6-f5d445f4b69d',
          'e15694cd-e146-494a-e053-2a95a90ab52d',
          '3cf1ef4b-a2c0-416a-80be-59c4d65d2dfc',
          '9b7353bb-a098-2fef-e053-2995a90a7529',
          'b670fd52-7f65-e416-e053-2a95a90ac7b7',
          '868a3891-1f5d-4ffb-beb6-df53847f07bb',
          '83183fad-270e-4176-8a0d-eb1be5456489',
          '17a747c1-84bd-4288-bfdd-192566d37a1b'
        )
      )
    )
    OR (
      (cs.vocabulary_id = "RxNorm Extension")
      AND (
        cs.concept_code IN (
          'OMOP379517',
          'OMOP379514',
          'OMOP379519',
          'OMOP379520',
          'OMOP379518',
          'OMOP2749312',
          'OMOP2765976',
          'OMOP2023321',
          'OMOP2053344',
          'OMOP2053345'
        )
      )
      AND (
        (
          ct.valid_start_date <= DATE('2008-01-01')
          OR ct.valid_start_date IS NULL
        )
        AND (
          ct.valid_end_date >= DATE('2010-12-31')
          OR ct.valid_end_date IS NULL
        )
      )
    )
),

-- Create AIDS condition codes in SNOMED
AIDS_codes AS (
  SELECT
    cs.concept_id AS source_concept_id,
    cs.concept_code AS icd_code,
    cs.concept_name AS icd_name,
    ct.concept_id AS standard_concept_id,
    ct.concept_code AS snomed_code,
    ct.concept_name AS snomed_name,
    ct.valid_start_date AS valid_start_date,
    ct.valid_end_date AS valid_end_date,
  FROM
    `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS cs
    JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.concept_relationship` AS cr ON cr.concept_id_1 = cs.concept_id
    JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS ct ON ct.concept_id = cr.concept_id_2
  WHERE
    (
      (
        (cs.vocabulary_id = "SNOMED")
        AND (
          cs.concept_code IN (
            "439421000124102",
            "1343305005",
            "673571000000106",
            "103413000",
            "103414006",
            "103408004",
            "103412005",
            "103411003",
            "103418009",
            "170470004",
            "170492000",
            "170530008",
            "16810008",
            "286880007",
            "273454004",
            "273263000",
            "416729007",
            "420281004",
            "420787001",
            "420818005",
            "420900006",
            "421009000",
            "421047005",
            "421184005",
            "421230000",
            "420244003",
            "420321004",
            "420384005",
            "420395004",
            "421403008",
            "421415007",
            "420543008",
            "420544002",
            "420718004",
            "421792005",
            "421837008",
            "421883002",
            "421979003",
            "421983003",
            "420308006",
            "420452002",
            "420524008",
            "421023003",
            "421218006",
            "421272004",
            "421312009",
            "421394009",
            "421431004",
            "422337001",
            "420614009",
            "420764009",
            "420801006",
            "420945005",
            "420991002",
            "421508002",
            "421510000",
            "421874007",
            "421102007",
            "421454008",
            "421998001",
            "422003001",
            "422031005",
            "422241000",
            "422282000",
            "420302007",
            "420403001",
            "420549007",
            "420554003",
            "420615005",
            "421571007",
            "421597001",
            "421695000",
            "421706001",
            "421710003",
            "421766003",
            "421835000",
            "421929001",
            "420658009",
            "420687005",
            "420691000",
            "420749009",
            "420774007",
            "420877009",
            "420938005",
            "421077004",
            "421977001",
            "422012004",
            "422074008",
            "422127002",
            "422159009",
            "421154002",
            "421189000",
            "421214008",
            "421283008",
            "421315006",
            "421460008",
            "421473007",
            "421529006",
            "421660003",
            "421666009",
            "421671002",
            "421708000",
            "421827003",
            "421851008",
            "422052002",
            "422089004",
            "422136003",
            "422177004",
            "422189002",
            "422194002",
            "422260007",
            "359791000",
            "406528008",
            "91923005",
            "409113002",
            "62479008",
            "62246005",
            "77070006",
            "1090791000000106",
            "1090801000000105",
            "781146004",
            "781147008",
            "1260096003",
            "999002431000000102",
            "178257007",
            "10479001",
            "11303005",
            "111881002",
            "111882009",
            "111883004",
            "111884005",
            "111885006",
            "111886007",
            "111887003",
            "111888008",
            "111889000",
            "1170003",
            "12019006",
            "11837006",
            "12741002",
            "13452004",
            "13556003",
            "14249000",
            "1362002",
            "15118008",
            "147723008",
            "147745009",
            "147784004",
            "15427004",
            "154367007",
            "15884001",
            "157000",
            "16437002",
            "160973006",
            "266200005",
            "26118004",
            "268593006",
            "28077005",
            "29099009",
            "186705005",
            "19423005",
            "19285002",
            "20197001",
            "20421002",
            "22892000",
            "23488005",
            "2555007",
            "2520005",
            "46531005",
            "46910000",
            "46933004",
            "45166008",
            "45529006",
            "45719002",
            "313113003",
            "31363004",
            "312261006",
            "3211006",
            "314103003",
            "34952005",
            "33579009",
            "33615004",
            "33745006",
            "36154007",
            "359775003",
            "359778001",
            "359787005",
            "35372003",
            "38118004",
            "37721008",
            "39047000",
            "398173000",
            "39363001",
            "42028002",
            "54962007",
            "51229007",
            "56301005",
            "60690004",
            "60696005",
            "63536001",
            "6357002",
            "61800002",
            "58002003",
            "62102009",
            "58522005",
            "62395007",
            "69154000",
            "71479007",
            "71646001",
            "6764002",
            "7019004",
            "68313006",
            "64473008",
            "68766007",
            "73266005",
            "77865003",
            "76242005",
            "80440003",
            "74633007",
            "768007",
            "77484008",
            "77524007",
            "88693009",
            "84350008",
            "84487004",
            "87014001",
            "87129002",
            "89706008",
            "89395004",
            "8944008",
            "87653009",
            "90194001",
            "87769005",
            "89565008",
            "8350005",
            "83659007",
            "88136003",
            "83983002",
            "8402005",
            "906000",
            "697965002"
          )
        )
      )
      AND (
        (
          ct.valid_start_date <= DATE('2008-01-01')
          OR ct.valid_start_date IS NULL
        )
        AND (
          ct.valid_end_date >= DATE('2010-12-31')
          OR ct.valid_end_date IS NULL
        )
      )
    )
)

-- Include cohort women under 60 and over 60 by 2010
SELECT
  p.person_id,
  p.year_of_birth,
  cs.concept_name AS gender_name,
  hc.icd_name AS HIV_condition_name,

  -- earliest HIV condition occurence as start point
  MIN(hiv.condition_start_date) AS hiv_condition_start_date,
  aic.icd_name AS AIDS_condition_name,
  -- earliest AIDS condition occurence as end point
  MIN(aids.condition_start_date) AS aids_condition_start_date,
  
  -- progress time from HIV to AIDS
  DATE_DIFF(
    MIN(aids.condition_start_date),
    MIN(hiv.condition_start_date),
    DAY
  ) AS days_to_AIDS,

  -- medication usage between start_point and end_point
  ct.concept_name AS drug_name,
  MIN(d.drug_exposure_start_date) AS drug_exposure_start_date,
  count(d.drug_exposure_start_date) AS drug_exposure_cycle,
  AVG(d.days_supply) AS average_days_supply

FROM
  `bigquery-public-data.cms_synthetic_patient_data_omop.person` AS p
  JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS cs ON p.gender_concept_id = cs.concept_id
  JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.drug_exposure` AS d ON p.person_id = d.person_id
  JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS ct ON d.drug_concept_id = ct.concept_id
  JOIN Atripla_codes AS ac ON d.drug_concept_id = ac.standard_concept_id -- HIV join
  LEFT JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.condition_occurrence` AS hiv ON p.person_id = hiv.person_id
  JOIN hiv_codes AS hc ON hiv.condition_concept_id = hc.standard_concept_id -- AIDS join
  LEFT JOIN `bigquery-public-data.cms_synthetic_patient_data_omop.condition_occurrence` AS aids ON p.person_id = aids.person_id
  JOIN AIDS_codes AS aic ON aids.condition_concept_id = aic.standard_concept_id
WHERE
  (
    p.gender_concept_id = 8532 -- Female
    AND p.year_of_birth > 1950
  ) -- get over60.csv, change to "p.year_of_birth >= 1950" to get under60.csv
  AND hiv.condition_start_date >= DATE('2008-01-01') -- include the time of interest
  AND aids.condition_start_date > hiv.condition_start_date -- Exclude entity: AIDS condition is ealier than HIV condition reported
  AND (
    d.drug_exposure_start_date >= hiv.condition_start_date -- Exclude entity: drug_exposure is ealier than HIV condition reported
    AND d.drug_exposure_start_date <= aids.condition_start_date -- Exclude entity: drug_exposure after than AIDS condition reported
  ) 
GROUP BY
  p.person_id,
  p.year_of_birth,
  cs.concept_name,
  hc.icd_name,
  aic.icd_name,
  ct.concept_name
LIMIT
  1000;