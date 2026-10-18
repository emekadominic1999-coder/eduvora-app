// BIO 102 (General Biology II) - hand-set questions: genetics, cell division, energy, evolution, ecology, physiology.
const L = require('../sta/lib');
const { add, out } = L;
const T = {
  gen: 'Mendelian Genetics', pop: 'Population Genetics', xl: 'X-linked Inheritance', dna: 'DNA, Transcription and Translation', mut: 'Mutations', mit: 'Mitosis', mei: 'Meiosis', cyc: 'Cell Cycle',
  pho: 'Photosynthesis', res: 'Cellular Respiration Overview', evo: 'Evolution and Natural Selection', eco: 'Ecosystems and Energy Flow', cyc2: 'Nutrient Cycles', pop2: 'Population Ecology', sym: 'Symbiotic Relationships',
  dig: 'Digestive System', circ: 'Circulatory System', resp: 'Respiratory System', exc: 'Excretion and the Kidney', hor: 'Hormones and Homeostasis', nerv: 'Nervous System', plant: 'Plant Growth Regulators',
};
const chk = (a, b) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed ' + a + ' vs ' + b); };

// ---------------- genetics
add('Two heterozygous tall pea plants (Tt × Tt) are crossed. The expected ratio of tall to dwarf offspring is:', '3 : 1', ['1 : 1', '1 : 2 : 1', '9 : 3 : 3 : 1'], 'The Punnett square gives 1 TT : 2 Tt : 1 tt, so three tall (T–) to one dwarf (tt).', T.gen);
add('In the cross Aa × Aa, the probability that an offspring is homozygous recessive is:', '1/4', ['1/2', '3/4', '1/8'], 'Aa × Aa gives AA, Aa, Aa, aa in equal chances, so aa = 1/4.', T.gen);
add('A test cross is made by crossing an individual of unknown genotype with:', 'A homozygous recessive individual', ['A homozygous dominant individual', 'A heterozygote', 'An unrelated species'], 'The offspring ratio reveals whether the unknown parent was homozygous or heterozygous.', T.gen);
add('The expected phenotypic ratio from the dihybrid cross AaBb × AaBb, with complete dominance at both loci, is:', '9 : 3 : 3 : 1', ['3 : 1', '1 : 1 : 1 : 1', '1 : 2 : 1'], 'Independent assortment gives 9 double dominant, 3, 3 and 1 double recessive.', T.gen);
add('In the cross AaBb × AaBb the probability that an offspring is aabb is:', '1/16', ['1/4', '1/8', '3/16'], '(1/4) × (1/4) = 1/16 for independent genes.', T.gen);
add('Crossing a red-flowered snapdragon with a white-flowered one gives all pink offspring. This is an example of:', 'Incomplete dominance', ['Codominance', 'Complete dominance', 'Epistasis'], 'Neither allele completely masks the other, so the heterozygote is intermediate.', T.gen);
add('A person with blood group AB has the genotype I^A I^B. This shows that the alleles are:', 'Codominant', ['Recessive', 'Incompletely dominant', 'Epistatic'], 'Both alleles are fully expressed in the heterozygote.', T.gen);
add('A man with blood group O and a woman with blood group AB have children. The blood groups possible among their children are:', 'A or B only', ['A, B, AB and O', 'AB only', 'O only'], 'The man can pass on only i and the woman I^A or I^B, so the children are I^A i (group A) or I^B i (group B).', T.gen);
add('Mendel\'s law of segregation states that:', 'The two alleles for a gene separate during gamete formation', ['Genes on different chromosomes are always linked', 'Dominant alleles always appear in the next generation', 'Alleles blend together in the offspring'], 'Each gamete receives only one allele of each pair.', T.gen);
add('A couple have three children, all boys. The probability that their fourth child is a boy is:', '1/2', ['1/16', '1/8', '3/4'], 'Each birth is independent, so the chance remains 1/2.', T.gen);
add('The probability that a family of three children has exactly two girls and one boy is:', '3/8', ['1/8', '1/4', '1/2'], 'Three arrangements (GGB, GBG, BGG) each with probability 1/8.', T.gen);
add('Red–green colour blindness is caused by a recessive X-linked allele. A colour-blind woman marries a man with normal vision. Their children will be:', 'All sons colour-blind and all daughters carriers', ['All children normal', 'All sons normal and all daughters colour-blind', 'Half the sons colour-blind and half the daughters colour-blind'], 'Sons receive the mother\'s X (X^c) and are colour-blind; daughters receive X^c from the mother and a normal X from the father.', T.xl);
add('Haemophilia is more common in males than in females because:', 'The allele is carried on the X chromosome and males have only one X', ['The allele is carried on the Y chromosome', 'Males produce less clotting factor', 'It is dominant in males only'], 'A single recessive X-linked allele is expressed in males.', T.xl);
add('Genes that lie close together on the same chromosome and tend to be inherited together are said to be:', 'Linked', ['Codominant', 'Epistatic', 'Independent'], 'Crossing over occasionally separates linked alleles.', T.gen);
add('If 10% of the offspring of a test cross are recombinants, the two genes are:', '10 map units apart', ['10 chromosomes apart', 'Unlinked', 'On different chromosomes'], 'One map unit (centimorgan) corresponds to 1% recombination.', T.gen);
add('In a population in Hardy–Weinberg equilibrium, 4% of individuals show a recessive trait (q² = 0.04). The frequency of the recessive allele is:', '0.2', ['0.04', '0.4', '0.02'], 'q = √0.04 = 0.2.', T.pop);
add('For the same population (q = 0.2), the proportion of heterozygous carriers (2pq) is:', '0.32', ['0.16', '0.64', '0.04'], 'p = 0.8, so 2pq = 2 × 0.8 × 0.2 = 0.32.', T.pop);

// ---------------- molecular genetics
add('The Meselson–Stahl experiment showed that DNA replication is:', 'Semi-conservative', ['Conservative', 'Dispersive', 'Random'], 'Each new double helix has one old strand and one new strand.', T.dna);
add('In a DNA molecule 30% of the bases are adenine. The percentage of guanine is:', '20%', ['30%', '40%', '70%'], 'A = T = 30%, so G + C = 40% and G = 20%.', T.dna);
add('The mRNA transcribed from the DNA template strand 3′–TACGGT–5′ is:', '5′–AUGCCA–3′', ['5′–ATGCCA–3′', '5′–UACGGU–3′', '5′–TACGGT–3′'], 'RNA pairs A–U, T–A, C–G, G–C with the template and uses uracil in place of thymine.', T.dna);
add('The start codon that begins the translation of most proteins is:', 'AUG', ['UAA', 'UGA', 'GGG'], 'AUG codes for methionine; UAA, UAG and UGA are stop codons.', T.dna);
add('A section of mRNA is 90 nucleotides long and contains a start codon but no stop codon within it. The greatest number of amino acids it can code for is:', '30', ['90', '45', '270'], 'Each codon of three nucleotides specifies one amino acid: 90 ÷ 3 = 30.', T.dna);
add('Transfer RNA brings amino acids to the ribosome and matches its anticodon to the:', 'Codon on mRNA', ['Promoter on DNA', 'Template DNA strand', 'rRNA'], 'Complementary base pairing between codon and anticodon ensures the correct amino acid is added.', T.dna);
add('Translation takes place at the:', 'Ribosomes', ['Nucleolus', 'Lysosomes', 'Golgi apparatus'], 'Transcription occurs in the nucleus of eukaryotes; translation in the cytoplasm.', T.dna);
add('Sickle-cell anaemia is caused by a:', 'Point mutation that substitutes valine for glutamic acid in haemoglobin', ['Deletion of a whole chromosome', 'Virus infection of red cells', 'Lack of iron in the diet'], 'A single base change (GAG to GTG) alters one amino acid in the β-chain.', T.mut);
add('The insertion of one extra nucleotide into a gene is likely to cause a:', 'Frameshift mutation', ['Silent mutation', 'Missense mutation with one changed amino acid only', 'No change in the protein'], 'The reading frame shifts, altering every codon after the insertion.', T.mut);
add('Down syndrome in humans is caused by:', 'An extra copy of chromosome 21 (trisomy 21)', ['A deletion on chromosome 5', 'A sex-linked recessive allele', 'A virus'], 'It results from non-disjunction during meiosis, giving 47 chromosomes.', T.mut);

// ---------------- cell division
add('The correct order of the stages of mitosis is:', 'Prophase, metaphase, anaphase, telophase', ['Prophase, anaphase, metaphase, telophase', 'Metaphase, prophase, anaphase, telophase', 'Prophase, metaphase, telophase, anaphase'], 'Chromosomes condense, align at the equator, separate, then reform nuclei.', T.mit);
add('During which stage of mitosis do sister chromatids separate and move to opposite poles?', 'Anaphase', ['Prophase', 'Metaphase', 'Telophase'], 'The centromeres split and spindle fibres shorten.', T.mit);
add('A human skin cell (2n = 46) divides by mitosis. Each daughter cell has:', '46 chromosomes', ['23 chromosomes', '92 chromosomes', '44 chromosomes'], 'Mitosis produces two genetically identical diploid cells.', T.mit);
add('In plant cells, cytokinesis occurs by the formation of a:', 'Cell plate', ['Cleavage furrow', 'Contractile ring', 'Centriole'], 'Vesicles fuse at the equator to form a new cell wall.', T.mit);
add('Meiosis differs from mitosis in that meiosis:', 'Produces four genetically different haploid cells from one diploid cell', ['Produces two identical diploid cells', 'Has one division only', 'Occurs in all body cells'], 'Two divisions follow a single round of DNA replication.', T.mei);
add('Crossing over occurs during:', 'Prophase I of meiosis', ['Anaphase II of meiosis', 'Prophase of mitosis', 'Metaphase of mitosis'], 'Homologous chromosomes pair and exchange segments at chiasmata.', T.mei);
add('A cell with 2n = 8 undergoes meiosis. Each gamete produced contains:', '4 chromosomes', ['8 chromosomes', '2 chromosomes', '16 chromosomes'], 'Meiosis halves the chromosome number.', T.mei);
add('Independent assortment of homologous chromosomes at metaphase I contributes to genetic variation because:', 'Each gamete receives a random mixture of maternal and paternal chromosomes', ['It copies the chromosomes twice', 'It prevents crossing over', 'It makes the cells diploid'], 'A human can make 2²³ different chromosome combinations in gametes.', T.mei);
add('The stage of the cell cycle in which DNA is replicated is the:', 'S phase', ['G1 phase', 'M phase', 'G2 phase'], 'S stands for synthesis; each chromosome then consists of two chromatids.', T.cyc);
add('Cancer cells are best described as cells that:', 'Divide uncontrollably because normal cell-cycle checkpoints have failed', ['Never replicate DNA', 'Cannot undergo mitosis', 'Have no nucleus'], 'Mutations in genes controlling the cell cycle remove its normal restraints.', T.cyc);

// ---------------- photosynthesis and respiration
add('The overall equation for photosynthesis is:', '6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂', ['C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O', '6CO₂ + 6O₂ → C₆H₁₂O₆ + 6H₂O', 'C₆H₁₂O₆ → 2C₂H₅OH + 2CO₂'], 'Light energy converts carbon dioxide and water into glucose and oxygen.', T.pho);
add('The light-dependent reactions of photosynthesis take place in the:', 'Thylakoid membranes of the chloroplast', ['Stroma', 'Mitochondrial matrix', 'Cytoplasm'], 'They produce ATP, NADPH and oxygen from the splitting of water.', T.pho);
add('The oxygen released during photosynthesis comes from:', 'Water', ['Carbon dioxide', 'Glucose', 'Chlorophyll'], 'Photolysis of water supplies electrons and releases O₂.', T.pho);
add('The Calvin cycle occurs in the:', 'Stroma of the chloroplast', ['Thylakoid lumen', 'Mitochondrion', 'Nucleus'], 'The enzyme RuBisCO fixes carbon dioxide to ribulose bisphosphate.', T.pho);
add('Chlorophyll absorbs light most strongly in the:', 'Blue and red regions', ['Green region', 'Yellow region', 'Infrared region'], 'Green light is mostly reflected, which is why leaves look green.', T.pho);
add('Which of the following is a limiting factor for photosynthesis?', 'Light intensity, carbon dioxide concentration and temperature', ['Only the colour of the leaf', 'Only the soil pH', 'Only the amount of water in the air'], 'The factor in shortest supply controls the rate at any moment.', T.pho);
add('Glycolysis takes place in the:', 'Cytoplasm', ['Mitochondrial matrix', 'Inner mitochondrial membrane', 'Nucleus'], 'It breaks glucose into two pyruvate molecules with a net gain of 2 ATP.', T.res);
add('The Krebs (TCA) cycle takes place in the:', 'Mitochondrial matrix', ['Cytoplasm', 'Thylakoid', 'Golgi apparatus'], 'Acetyl-CoA is oxidised, releasing carbon dioxide and reduced coenzymes.', T.res);
add('Most of the ATP in aerobic respiration is made by:', 'The electron transport chain and oxidative phosphorylation', ['Glycolysis', 'The Krebs cycle', 'Fermentation'], 'About 26–28 of the roughly 30–32 ATP per glucose come from this stage.', T.res);
add('Yeast cells that ferment glucose in the absence of oxygen produce:', 'Ethanol and carbon dioxide', ['Lactic acid and water', 'Pyruvate and oxygen', 'Glycerol only'], 'Alcoholic fermentation regenerates NAD⁺ so glycolysis can continue.', T.res);
add('During strenuous exercise, muscle cells short of oxygen produce:', 'Lactic acid', ['Ethanol', 'Acetic acid', 'Glucose'], 'Pyruvate is reduced to lactate, regenerating NAD⁺.', T.res);
add('The final electron acceptor in the mitochondrial electron transport chain is:', 'Oxygen', ['Carbon dioxide', 'NAD⁺', 'Pyruvate'], 'Oxygen combines with electrons and hydrogen ions to form water.', T.res);

// ---------------- evolution
add('For natural selection to occur in a population there must be:', 'Heritable variation and differences in survival and reproduction', ['No variation among individuals', 'Equal survival of all individuals', 'Acquired characteristics passed on'], 'Individuals with favourable heritable traits leave more offspring.', T.evo);
add('The idea that giraffes\' necks lengthened because they stretched to reach leaves and this was passed on is associated with:', 'Lamarck', ['Darwin', 'Mendel', 'Wallace'], 'Inheritance of acquired characteristics has been disproved; selection acts on heritable variation.', T.evo);
add('The wing of a bat and the arm of a human are:', 'Homologous structures', ['Analogous structures', 'Vestigial structures', 'Convergent organs'], 'They have the same bone plan inherited from a common ancestor.', T.evo);
add('The wings of a butterfly and the wings of a bird are:', 'Analogous structures', ['Homologous structures', 'Vestigial structures', 'Identical in origin'], 'They perform the same function but evolved independently.', T.evo);
add('Bacteria becoming resistant to an antibiotic is an example of:', 'Natural selection acting on existing variation', ['The need of bacteria to become resistant', 'Use and disuse', 'Mutation caused by the antibiotic on purpose'], 'Resistant bacteria survive the drug and pass on the resistance genes.', T.evo);
add('Allopatric speciation occurs when populations:', 'Become geographically isolated and diverge', ['Mate freely in the same area', 'Have identical gene pools', 'Live in the same habitat'], 'Isolation stops gene flow, so the populations accumulate different adaptations.', T.evo);
add('A sudden change in allele frequencies in a small population due to chance is called:', 'Genetic drift', ['Natural selection', 'Gene flow', 'Mutation pressure'], 'Drift has stronger effects in small populations.', T.pop);
add('The vermiform appendix in humans is described as a:', 'Vestigial structure', ['Analogous structure', 'Homologous organ', 'Convergent feature'], 'It is a reduced remnant of a structure that was larger in ancestors.', T.evo);

// ---------------- ecology
add('Roughly what percentage of energy is passed from one trophic level to the next?', '10%', ['50%', '90%', '1%'], 'The rest is lost as heat, in respiration and in uneaten parts.', T.eco);
add('If producers in a food chain fix 10 000 kJ of energy, the energy available to the secondary consumers is about:', '100 kJ', ['1 000 kJ', '10 kJ', '5 000 kJ'], 'Producers → primary consumers (1 000 kJ) → secondary consumers (100 kJ) at 10% transfer.', T.eco);
add('In the food chain grass → grasshopper → frog → snake, the frog is a:', 'Secondary consumer', ['Primary consumer', 'Producer', 'Decomposer'], 'It feeds on the primary consumer (grasshopper).', T.eco);
add('Organisms that break down dead material and return nutrients to the soil are:', 'Decomposers', ['Producers', 'Primary consumers', 'Predators'], 'Bacteria and fungi are the main decomposers.', T.eco);
add('A pyramid of energy is always upright because:', 'Energy is lost at each trophic level', ['Producers are always smaller in number', 'Consumers are always larger', 'Energy is created at each level'], 'Less energy is available at each higher level.', T.eco);
add('Nitrogen-fixing bacteria such as Rhizobium live in:', 'Root nodules of leguminous plants', ['The leaves of cereals', 'The stomach of cattle only', 'The wood of trees'], 'They convert atmospheric nitrogen into ammonia for the plant.', T.cyc2);
add('The conversion of ammonium ions to nitrates by soil bacteria is called:', 'Nitrification', ['Denitrification', 'Ammonification', 'Nitrogen fixation'], 'Nitrosomonas and Nitrobacter carry out the two steps.', T.cyc2);
add('Denitrification returns nitrogen to the atmosphere. It is carried out by bacteria that:', 'Convert nitrate into nitrogen gas in waterlogged, oxygen-poor soil', ['Fix nitrogen into ammonia', 'Convert ammonia to nitrate', 'Absorb nitrogen from the air for plants'], 'It reduces the nitrogen available to crops.', T.cyc2);
add('A graph of population size against time that rises steeply, then levels off at the carrying capacity, shows:', 'Logistic growth', ['Exponential growth only', 'Population crash', 'Negative growth'], 'Limiting resources slow growth as the population nears carrying capacity.', T.pop2);
add('Carrying capacity is the:', 'Maximum population size an environment can sustain', ['Number of births per year', 'Total number of species in an area', 'Average age of a population'], 'It depends on food, space and other limiting factors.', T.pop2);
add('The relationship between a tick and the animal on which it feeds is an example of:', 'Parasitism', ['Mutualism', 'Commensalism', 'Competition'], 'The parasite benefits at the host\'s expense.', T.sym);
add('Rhizobium bacteria and a legume plant have a relationship that is best described as:', 'Mutualism', ['Parasitism', 'Commensalism', 'Predation'], 'The plant gets nitrogen compounds and the bacteria get sugars and shelter.', T.sym);
add('An orchid growing on the branch of a tree without harming it is an example of:', 'Commensalism', ['Mutualism', 'Parasitism', 'Competition'], 'The epiphyte benefits and the tree is unaffected.', T.sym);
add('Which gas released by burning fossil fuels is the main contributor to the enhanced greenhouse effect?', 'Carbon dioxide', ['Nitrogen', 'Oxygen', 'Argon'], 'Methane and nitrous oxide also contribute.', T.eco);

// ---------------- human physiology
add('Salivary amylase begins the digestion of:', 'Starch', ['Protein', 'Fats', 'Cellulose'], 'It hydrolyses starch to maltose in the mouth.', T.dig);
add('The enzyme pepsin works best in the stomach because the stomach has a:', 'Very low (acidic) pH', ['High alkaline pH', 'Neutral pH', 'High temperature'], 'Hydrochloric acid gives a pH of about 2.', T.dig);
add('Bile is made in the liver and stored in the gall bladder. Its main function is to:', 'Emulsify fats', ['Digest proteins', 'Break down starch', 'Produce insulin'], 'Bile salts break fat into droplets, increasing the surface area for lipase.', T.dig);
add('Most absorption of digested food takes place in the:', 'Small intestine', ['Stomach', 'Large intestine', 'Oesophagus'], 'Villi and microvilli provide a very large surface area.', T.dig);
add('Blood leaving the right ventricle of the heart goes to the:', 'Lungs', ['Whole body', 'Liver', 'Kidneys'], 'The pulmonary artery carries deoxygenated blood to the lungs.', T.circ);
add('Arteries have thick, elastic walls because they:', 'Carry blood at high pressure from the heart', ['Carry blood back to the heart', 'Exchange gases with tissues', 'Store blood'], 'The elastic walls stretch and recoil with each heartbeat.', T.circ);
add('During inhalation the diaphragm:', 'Contracts and moves down, increasing the volume of the chest', ['Relaxes and moves up', 'Contracts and moves up', 'Remains still'], 'The pressure in the lungs falls below atmospheric pressure and air flows in.', T.resp);
add('Gas exchange in the lungs occurs across the walls of the:', 'Alveoli', ['Bronchi', 'Trachea', 'Bronchioles'], 'Alveoli are thin-walled and surrounded by capillaries.', T.resp);
add('The hormone ADH helps regulate water balance by:', 'Increasing the reabsorption of water in the kidney tubules', ['Decreasing water reabsorption', 'Increasing sodium excretion only', 'Stimulating thirst only'], 'Release of ADH makes the urine more concentrated.', T.exc);
add('Ultrafiltration in the kidney takes place in the:', 'Glomerulus and Bowman\'s capsule', ['Loop of Henle', 'Collecting duct', 'Ureter'], 'High pressure forces small molecules out of the blood into the capsule.', T.exc);
add('Insulin lowers the concentration of glucose in the blood by:', 'Promoting uptake of glucose by cells and storage as glycogen', ['Breaking down glycogen', 'Making the kidneys excrete glucose', 'Stopping food digestion'], 'It is made by the β-cells of the pancreas.', T.hor);
add('Homeostatic control of blood sugar is an example of:', 'Negative feedback', ['Positive feedback', 'Reflex action', 'Adaptation'], 'A change in glucose triggers a response that returns it to the normal level.', T.hor);
add('The correct sequence in a simple reflex arc is:', 'Receptor → sensory neurone → relay neurone → motor neurone → effector', ['Receptor → motor neurone → relay neurone → sensory neurone → effector', 'Effector → sensory neurone → receptor', 'Receptor → effector → sensory neurone'], 'The signal passes through the spinal cord without needing the brain.', T.nerv);
add('The chemical released at a synapse to transmit a nerve impulse is a:', 'Neurotransmitter', ['Hormone from the pancreas', 'Enzyme', 'Antibody'], 'Acetylcholine is a common example.', T.nerv);

// ---------------- plants
add('The bending of a shoot towards light is caused by:', 'Auxin accumulating on the shaded side, causing greater cell elongation', ['Auxin accumulating on the lighted side', 'Gibberellin stopping growth', 'Water loss on the shaded side'], 'Unequal growth makes the shoot curve towards the light.', T.plant);
add('The plant hormone that promotes fruit ripening is:', 'Ethylene', ['Auxin', 'Cytokinin', 'Abscisic acid'], 'A ripe banana releases ethylene, which speeds the ripening of neighbouring fruit.', T.plant);
add('Abscisic acid causes:', 'Closure of stomata during water stress', ['Cell elongation', 'Fruit ripening', 'Breaking of seed dormancy'], 'It also helps maintain seed dormancy.', T.plant);
add('Water moves up a tall tree mainly because of:', 'Transpiration pull and cohesion of water molecules', ['Active pumping by the xylem', 'Pressure from the phloem', 'Gravity'], 'Evaporation from leaves pulls a continuous column of water through the xylem.', T.plant);
add('Gibberellins are used to:', 'Break seed dormancy and promote stem elongation', ['Close stomata', 'Ripen fruit', 'Kill weeds'], 'They stimulate the enzymes that mobilise food reserves in germinating seeds.', T.plant);

module.exports = out;
