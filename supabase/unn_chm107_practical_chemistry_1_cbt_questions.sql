-- CHM 107: General Chemistry Practical I (old code CHEM 171 -- assumed from the
-- "CHM 171-107" timetable; please confirm)
-- =============================================================================
-- 39 questions imported from the supplied CHM 107 practical quiz
-- (stoichiometry and titration, qualitative analysis). Every numeric answer was
-- recomputed. One question was dropped: "Calculate the molar mass if 4.9 g gives
-- a 250 cm3 solution of 0.0474 mol/dm3" had an inconsistent answer and explanation.
-- ASSUMPTIONS: 100 Level, first semester, 1 unit.
-- =============================================================================
-- This file ONLY ADDS. If a subject whose name starts with 'CHM 107' already
-- exists, the new questions join it (same id, name, faculty, level, semester and
-- units). Otherwise a new subject 'chm-107-practical-chemistry-1' is created. A question whose text is
-- already in that subject is skipped, so running the file twice is safe.
with src (question, options, correct_index, explanation, topic) as (
values
  ('What is the molarity of a solution containing 4.9 g of ferrous ammonium sulphate hexahydrate (molar mass = 392 g/mol) dissolved in 250 cm³ of solution?', '["0.025 mol/dm³","0.050 mol/dm³","0.100 mol/dm³","0.200 mol/dm³"]'::jsonb, 1, 'Molarity = (mass/molar mass) × (1000/volume) = (4.9/392) × (1000/250) = 0.0125 × 4 = 0.050 mol/dm³', 'Stoichiometry and Titration'),
  ('How much ferrous ammonium sulphate hexahydrate (molar mass = 392 g/mol) is needed to prepare 250 cm³ of M/50 solution?', '["1.96 g","3.92 g","0.98 g","7.84 g"]'::jsonb, 0, 'M/50 = 0.02 mol/dm³. Mass = 0.02 × 0.25 × 392 = 1.96 g', 'Stoichiometry and Titration'),
  ('In a titration: Ca = ?, Va = 25 cm³, na = 1, Cb = 0.0975 mol/dm³, Vb = 24.30 cm³, nb = 2. What is Ca?', '["0.0474 mol/dm³","0.0948 mol/dm³","0.0237 mol/dm³","0.1000 mol/dm³"]'::jsonb, 0, 'CaVa/na = CbVb/nb → Ca×25/1 = 0.0975×24.30/2 → Ca = (0.0975×24.30)/(2×25) = 0.0474 mol/dm³', 'Stoichiometry and Titration'),
  ('Using the titration formula CaVa/na = CbVb/nb, what does the subscript "a" represent?', '["Acid","Alkali","Anion","Aqueous"]'::jsonb, 0, 'Subscript "a" = acid; subscript "b" = base.', 'Stoichiometry and Titration'),
  ('A standard solution is best described as:', '["A solution of known concentration (mol/litre)","A solution at standard temperature","A solution with pH 7","A saturated solution at 25°C"]'::jsonb, 0, 'A standard solution has a precisely known concentration in mol/litre.', 'Stoichiometry and Titration'),
  ('A molar solution contains:', '["1 gram of solute per dm³","1 mole of solute per dm³ of solution","1 mole of solute per kg of solvent","1 millimole per cm³"]'::jsonb, 1, 'A molar solution contains one gram molecular weight (one mole) of substance per dm³ of solution.', 'Stoichiometry and Titration'),
  ('Molarity is correctly defined as:', '["Mass of solute / volume of solution","Moles of solute / kg of solvent","Moles of solute / dm³ of solution","Moles of solvent / dm³ of solution"]'::jsonb, 2, 'Molarity = moles of solute per dm³ of solution (mol/dm³ or mol/L).', 'Stoichiometry and Titration'),
  ('What mass of Na₂C₂O₄ (molar mass = 134 g/mol) is needed to prepare 500 cm³ of M/15 solution?', '["4.47 g","8.93 g","2.24 g","13.40 g"]'::jsonb, 0, 'M/15 ≈ 0.0667 mol/dm³. Mass = 0.0667 × 0.5 dm³ × 134 = 4.47 g', 'Stoichiometry and Titration'),
  ('Which correctly expresses the titration formula?', '["CaVa / na = CbVb / nb","Ca × na = Cb × nb","Va / na = Vb / nb","Ca + Cb = na + nb"]'::jsonb, 0, 'The standard titration formula is CaVa/na = CbVb/nb.', 'Stoichiometry and Titration'),
  ('If 4.9 g of H₂SO₄ (molar mass = 98 g/mol) is dissolved to make 500 cm³ of solution, what is the molarity?', '["0.05 mol/dm³","0.10 mol/dm³","0.20 mol/dm³","1.00 mol/dm³"]'::jsonb, 1, 'n = 4.9/98 = 0.05 mol. M = 0.05/0.5 = 0.10 mol/dm³', 'Stoichiometry and Titration'),
  ('NaOH cannot be used as a primary standard because:', '["It is too expensive","It absorbs moisture and CO₂ from air, making its mass uncertain","It reacts too slowly","Its molar mass is unknown"]'::jsonb, 1, 'NaOH is hygroscopic and absorbs CO₂, so you cannot weigh out an accurately known amount.', 'Stoichiometry and Titration'),
  ('In titration, the end point is:', '["When the solution gives a permanent colour change","When half the acid is neutralised","When all the base has been added","When the indicator is first added"]'::jsonb, 0, 'The end point is when the indicator gives a permanent colour change, signalling completion.', 'Stoichiometry and Titration'),
  ('How many moles are in 4.9 g of ferrous ammonium sulphate hexahydrate (molar mass = 392 g/mol)?', '["0.00625 mol","0.0125 mol","0.025 mol","0.050 mol"]'::jsonb, 1, 'n = 4.9/392 = 0.0125 mol', 'Stoichiometry and Titration'),
  ('The colour of phenolphthalein in acid solution is:', '["Pink","Colourless","Yellow","Blue"]'::jsonb, 1, 'Phenolphthalein is colourless in acid and turns pink/red in alkali.', 'Stoichiometry and Titration'),
  ('The colour of methyl orange in alkaline solution is:', '["Red","Orange","Yellow","Colourless"]'::jsonb, 2, 'Methyl orange is red in acid and yellow in alkaline solution.', 'Stoichiometry and Titration'),
  ('The colour of methyl orange in acid solution is:', '["Yellow","Colourless","Red","Blue"]'::jsonb, 2, 'Methyl orange is red in acidic conditions and yellow in alkaline conditions.', 'Stoichiometry and Titration'),
  ('The colour of phenolphthalein in alkaline solution is:', '["Colourless","Yellow","Pink/Red","Blue"]'::jsonb, 2, 'Phenolphthalein is colourless in acid and turns pink/red in alkali.', 'Stoichiometry and Titration'),
  ('An indicator is best described as:', '["A substance that prevents titration errors","An organic substance that changes colour as pH changes","A strong acid used to calibrate solutions","A salt buffer solution"]'::jsonb, 1, 'An indicator is an organic substance whose colour changes with pH — used to detect the end point.', 'Stoichiometry and Titration'),
  ('Why do some titrations not require an indicator?', '["They are too fast","They involve coloured substances that serve as their own indicators","They use pH meters instead","The reaction is in the dark"]'::jsonb, 1, 'Titrations with naturally coloured substances (e.g. KMnO₄) do not need an external indicator.', 'Stoichiometry and Titration'),
  ('If 25 cm³ of HCl neutralises 20 cm³ of 0.1 mol/dm³ NaOH (1:1 ratio), what is [HCl]?', '["0.08 mol/dm³","0.125 mol/dm³","0.10 mol/dm³","0.050 mol/dm³"]'::jsonb, 0, 'Ca×25 = 0.1×20 → Ca = 2/25 = 0.08 mol/dm³', 'Stoichiometry and Titration'),
  ('What volume of 0.5 mol/dm³ H₂SO₄ neutralises 40 cm³ of 0.25 mol/dm³ NaOH? (H₂SO₄:NaOH = 1:2)', '["10 cm³","20 cm³","40 cm³","80 cm³"]'::jsonb, 0, '0.5×Va/1 = 0.25×40/2 → Va = 5/0.5 = 10 cm³', 'Stoichiometry and Titration'),
  ('Molality is defined as:', '["Moles of solute per litre of solution","Moles of solute per kilogram of solvent","Grams of solute per litre","Moles of solvent per litre"]'::jsonb, 1, 'Molality = moles of solute per kilogram of solvent (not solution).', 'Stoichiometry and Titration'),
  ('The number of moles in 53 g of Na₂CO₃ (molar mass = 106 g/mol) is:', '["0.25 mol","0.50 mol","1.00 mol","2.00 mol"]'::jsonb, 1, 'n = 53/106 = 0.50 mol', 'Stoichiometry and Titration'),
  ('To make 1 dm³ of a 0.1 mol/dm³ NaCl solution (molar mass = 58.5 g/mol), you need:', '["5.85 g","11.7 g","0.585 g","58.5 g"]'::jsonb, 0, 'mass = 0.1 × 1 × 58.5 = 5.85 g', 'Stoichiometry and Titration'),
  ('Which of the following can be used to make a primary standard solution?', '["NaOH","HCl","Anhydrous Na₂CO₃","H₂SO₄"]'::jsonb, 2, 'Anhydrous Na₂CO₃ is stable and pure — a suitable primary standard. NaOH and HCl absorb moisture/CO₂.', 'Stoichiometry and Titration'),
  ('If 10 cm³ of acid is titrated against 0.1 mol/dm³ NaOH and 20 cm³ NaOH is used (1:1), what is [acid]?', '["0.05 mol/dm³","0.10 mol/dm³","0.20 mol/dm³","0.40 mol/dm³"]'::jsonb, 2, 'Ca×10 = 0.1×20 → Ca = 2/10 = 0.20 mol/dm³', 'Stoichiometry and Titration'),
  ('The molar mass of ferrous ammonium sulphate hexahydrate used in CHM 107 practical notes is:', '["278 g/mol","392 g/mol","284 g/mol","482 g/mol"]'::jsonb, 1, 'The notes explicitly state: molar mass of ferrous ammonium sulphate hexahydrate = 392 g/mol.', 'Stoichiometry and Titration'),
  ('In the formula Molarity = (mass/molar mass) × (1000/vol in cm³), multiplying by 1000 achieves:', '["Converts litres to cm³","Converts cm³ to dm³ for correct units","Adjusts for temperature","Converts grams to milligrams"]'::jsonb, 1, 'Multiplying by 1000/vol(cm³) converts the volume from cm³ to dm³, giving mol/dm³.', 'Stoichiometry and Titration'),
  ('Titrations involving KMnO₄ do not need an external indicator because:', '["They reach equilibrium instantly","KMnO₄ is intensely coloured and acts as its own indicator","They are done at high temperature","KMnO₄ reacts with indicators"]'::jsonb, 1, 'KMnO₄ is a self-indicator — its purple colour fades at the endpoint.', 'Stoichiometry and Titration'),
  ('Why can sodium carbonate (Na₂CO₃) extract NOT be used to confirm carbonate?', '["The extract already contains carbonate, giving a false positive","Carbonate does not dissolve in Na₂CO₃","Na₂CO₃ reacts with carbonate to form a gas","Na₂CO₃ is not soluble"]'::jsonb, 0, 'Na₂CO₃ extract already contains carbonate — using it to test for carbonate would always give a false positive.', 'Qualitative Analysis'),
  ('The anion that CANNOT be analysed using the dry test is:', '["Chloride (Cl⁻)","Sulphate (SO₄²⁻)","Nitrate (NO₃⁻)","Carbonate (CO₃²⁻)"]'::jsonb, 1, 'Sulphate cannot be analysed by dry test; it requires wet chemical methods.', 'Qualitative Analysis'),
  ('To confirm the presence of sulphate, the correct reagent sequence is:', '["Extract + dil HNO₃ + AgNO₃","Extract + dil HCl + BaCl₂","Extract + dil H₂SO₄ + KMnO₄","Extract + NaOH + litmus"]'::jsonb, 1, 'Sulphate is confirmed by: extract + dil HCl + BaCl₂ → white BaSO₄ precipitate.', 'Qualitative Analysis'),
  ('To confirm the presence of chloride, the correct reagent sequence is:', '["Extract + dil HCl + BaCl₂","Extract + dil HNO₃ + AgNO₃ → white precipitate","Extract + NH₄OH + NH₄Cl","Extract + NaOH + Nessler''s reagent"]'::jsonb, 1, 'Chloride is confirmed by: extract + dil HNO₃ + AgNO₃ → white AgCl precipitate.', 'Qualitative Analysis'),
  ('When 2M NH₄Cl and 2M NH₄OH are added to Group III radicals, the precipitate for Al³⁺ is:', '["Brown Al(OH)₃","Blue-green Al(OH)₃","White Al(OH)₃","No precipitate"]'::jsonb, 2, 'Al(OH)₃ is white. Cr(OH)₃ is blue-green; Fe(OH)₃ is brown.', 'Qualitative Analysis'),
  ('Cations are grouped into how many classes depending on their precipitating agent?', '["Four","Five","Six","Seven"]'::jsonb, 2, 'Cations are grouped into six classes based on their precipitating agent.', 'Qualitative Analysis'),
  ('The precipitating agent for Group I cations (Ag⁺, Hg₂²⁺, Pb²⁺) is:', '["NH₄OH","Dil HCl","(NH₄)₂CO₃","H₂S"]'::jsonb, 1, 'Group I cations are precipitated by dilute HCl.', 'Qualitative Analysis'),
  ('Group VI cations (Mg²⁺, Na⁺, K⁺, NH₄⁺) have no precipitating agent because:', '["They form coloured precipitates","They are highly soluble and do not precipitate easily","They are radioactive","They only exist in acidic solutions"]'::jsonb, 1, 'Group VI cations are highly soluble — their salts do not precipitate under standard conditions.', 'Qualitative Analysis'),
  ('The flame test colour for barium when viewed through cobalt glass is:', '["Purple","Apple green","Scarlet","Lilac"]'::jsonb, 1, 'Barium gives an apple green colour when viewed through cobalt glass.', 'Qualitative Analysis'),
  ('When Nessler''s reagent is added to a sample and an orange-brown colouration appears, the cation present is:', '["Na⁺","K⁺","NH₄⁺","Mg²⁺"]'::jsonb, 2, 'Nessler''s reagent produces an orange-brown colouration with NH₄⁺ (ammonium ion).', 'Qualitative Analysis')
),
tgt as (
  select subject_id, subject_name, faculty, department, level, semester, units
    from public.cbt_questions
   where subject_name ilike 'CHM 107%' and subject_id not like '%coming-soon'
   limit 1
)
insert into public.cbt_questions
  (subject_id, subject_name, institution, faculty, department, level,
   question, options, correct_index, explanation, topic, is_general, semester, units)
select coalesce(t.subject_id, 'chm-107-practical-chemistry-1'),
       coalesce(t.subject_name, 'CHM 107: General Chemistry Practical I'),
       'University of Nigeria, Nsukka',
       coalesce(t.faculty, 'Faculty of Physical Sciences, Faculty of Engineering, Faculty of Biological Sciences, Faculty of Veterinary Medicine, Faculty of Environmental Studies'),
       coalesce(t.department, 'Pure and Industrial Chemistry'),
       coalesce(t.level, '100 Level'),
       s.question, s.options, s.correct_index, s.explanation, s.topic, false,
       coalesce(t.semester, 'first'),
       coalesce(t.units, 1)
  from src s
  left join tgt t on true
 where not exists (
   select 1 from public.cbt_questions c
    where c.subject_id = coalesce(t.subject_id, 'chm-107-practical-chemistry-1') and c.question = s.question);

select subject_id, subject_name, count(*) as questions
  from public.cbt_questions
 where subject_name ilike 'CHM 107%' and subject_id not like '%coming-soon'
 group by 1, 2;
