// BIO 102 batch 2 - hand-set from OpenStax Biology 2e and Concepts of Biology. Medium difficulty.
const L = require('../sta/lib');
const { add, out } = L;
const T = {
  gen: 'Mendelian Genetics', pop: 'Population Genetics', xl: 'X-linked Inheritance', dna: 'DNA, Transcription and Translation', mut: 'Mutations', mit: 'Mitosis', mei: 'Meiosis', cyc: 'Cell Cycle',
  pho: 'Photosynthesis', res: 'Cellular Respiration Overview', evo: 'Evolution and Natural Selection', eco: 'Ecosystems and Energy Flow', cyc2: 'Nutrient Cycles', pop2: 'Population Ecology', sym: 'Symbiotic Relationships',
  dig: 'Digestive System', circ: 'Circulatory System', resp: 'Respiratory System', exc: 'Excretion and the Kidney', hor: 'Hormones and Homeostasis', nerv: 'Nervous System', plant: 'Plant Growth Regulators', rep: 'Reproduction and Development', imm: 'Immune System', bt: 'Biotechnology',
};
const chk = (a, b) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed ' + a + ' vs ' + b); };

// ---------------- genetics
add('A heterozygous plant with round seeds (Rr) is crossed with a wrinkled-seed plant (rr). The expected ratio of round to wrinkled offspring is:', '1 : 1', ['3 : 1', '2 : 1', 'All round'], 'This is a test cross: 1 Rr : 1 rr, so half are round and half are wrinkled.', T.gen);
add('Mendel\'s law of segregation states that:', 'The two alleles for a trait separate during gamete formation so each gamete carries one allele', ['Alleles of different genes are always inherited together', 'Dominant alleles always disappear in the next generation', 'Traits blend in the offspring'], 'Each gamete receives only one allele of each gene.', T.gen);
add('Mendel\'s law of independent assortment applies to genes that:', 'Are on different chromosomes or far apart on the same chromosome', ['Are linked closely on the same chromosome', 'Are located on sex chromosomes only', 'Are dominant'], 'Alleles of such genes sort into gametes independently.', T.gen);
add('The cross AaBb × AaBb, with the genes assorting independently, gives a phenotypic ratio of:', '9 : 3 : 3 : 1', ['3 : 1', '1 : 1 : 1 : 1', '1 : 2 : 1'], 'This is the classic dihybrid ratio when both traits show complete dominance.', T.gen);
add('The probability that a child of two carriers of an autosomal recessive disorder (Aa × Aa) will be affected is:', '1/4', ['1/2', '3/4', '1/8'], 'Only aa children are affected, one of four equally likely combinations.', T.gen);
add('In Aa × Aa, the probability that an unaffected child is a carrier is:', '2/3', ['1/2', '1/3', '3/4'], 'The unaffected children are AA (1/4) or Aa (2/4), so the carrier fraction is 2/4 ÷ 3/4 = 2/3.', T.gen);
chk(2 / 4 / (3 / 4), 2 / 3);
add('A plant with genotype Tt is described as:', 'Heterozygous', ['Homozygous dominant', 'Homozygous recessive', 'Haploid'], 'Heterozygous individuals carry two different alleles of the gene.', T.gen);
add('The physical appearance of an organism, determined by its genes and the environment, is its:', 'Phenotype', ['Genotype', 'Karyotype', 'Allele'], 'The genotype is the set of alleles it carries.', T.gen);
add('A red-flowered snapdragon crossed with a white-flowered snapdragon gives all pink offspring. This is an example of:', 'Incomplete dominance', ['Complete dominance', 'Codominance', 'Epistasis'], 'Neither allele is completely dominant, and the heterozygote has an intermediate phenotype.', T.gen);
add('A person with blood group AB shows:', 'Codominance', ['Incomplete dominance', 'Recessive inheritance', 'Epistasis'], 'Both IA and IB alleles are fully expressed.', T.gen);
add('A man of blood group A (genotype IAi) marries a woman of blood group B (genotype IBi). The possible blood groups of their children are:', 'A, B, AB and O', ['A and B only', 'AB only', 'A, B and AB only'], 'The gametes are IA or i from the man, and IB or i from the woman, giving IAIB, IAi, IBi and ii.', T.gen);
add('Which parents CANNOT have a child of blood group O?', 'AB and AB', ['A and B (both heterozygous)', 'A and A (both heterozygous)', 'O and B (heterozygous)'], 'Blood group O requires the genotype ii, so each parent must carry an i allele. A parent of group AB has none.', T.gen);
add('A single gene that affects several seemingly unrelated traits shows:', 'Pleiotropy', ['Polygenic inheritance', 'Epistasis', 'Linkage'], 'Sickle cell disease is an example, since one gene affects the shape of red cells, circulation and organ damage.', T.gen);
add('Human skin colour and height vary continuously because they are controlled by:', 'Several genes acting together, plus the environment', ['A single gene with two alleles', 'Genes on the Y chromosome', 'Mitochondrial genes only'], 'Polygenic traits show continuous variation.', T.gen);
add('Genes that are located close together on the same chromosome and tend to be inherited together are said to be:', 'Linked', ['Epistatic', 'Codominant', 'Autosomal only'], 'Crossing over occasionally separates them.', T.gen);
add('Crossing over occurs during:', 'Prophase I of meiosis', ['Metaphase of mitosis', 'Anaphase II of meiosis', 'Interphase of the cell cycle'], 'Homologous chromosomes pair and exchange segments, producing new combinations of alleles.', T.mei);
add('A test cross is used to find out:', 'Whether an individual showing the dominant phenotype is homozygous or heterozygous', ['The sex of an organism', 'How many chromosomes it has', 'Whether a gene is on the X chromosome'], 'The individual is crossed with a homozygous recessive.', T.gen);
add('Colour blindness is more common in men than in women because the gene:', 'Is recessive and carried on the X chromosome, and men have only one X', ['Is carried on the Y chromosome', 'Is dominant in men', 'Is carried on mitochondrial DNA'], 'A man with one defective allele is affected, while a woman needs two.', T.xl);
add('A colour-blind man (XcY) marries a woman who is homozygous with normal vision. Their sons will be:', 'All normal', ['All colour-blind', 'Half colour-blind', 'One quarter colour-blind'], 'Sons get their X from the mother (XC) and Y from the father, so they are XCY.', T.xl);
add('A woman who is a carrier of haemophilia (XHXh) marries a normal man. The probability that a son will have haemophilia is:', '1/2', ['1/4', '1', '0'], 'Sons receive either XH or Xh from the mother with equal chance.', T.xl);
add('In humans, the sex of the child is determined by:', 'The sperm, which carries either an X or a Y chromosome', ['The egg, which carries either an X or a Y', 'The mother only', 'The environment'], 'The egg always carries X.', T.xl);
add('Down syndrome is usually caused by:', 'Trisomy of chromosome 21 resulting from non-disjunction', ['A deletion in chromosome 21', 'A point mutation on the X chromosome', 'Monosomy of chromosome 21'], 'An extra copy of chromosome 21 gives 47 chromosomes.', T.mut);
add('A person with Turner syndrome has the karyotype:', '45, X', ['47, XXY', '47, XXX', '46, XY'], 'Turner syndrome is monosomy of the sex chromosomes, a female with one X.', T.mut);
add('Klinefelter syndrome is characterised by the karyotype:', '47, XXY', ['45, X', '47, XYY', '46, XX'], 'The person is male with an extra X.', T.mut);
add('Sickle cell anaemia results from:', 'A point mutation that replaces glutamic acid with valine in the beta chain of haemoglobin', ['An extra chromosome', 'Loss of a whole gene', 'A mutation in mitochondrial DNA'], 'A single base substitution changes one amino acid and the haemoglobin polymerises when deoxygenated.', T.mut);
add('Heterozygous carriers of the sickle cell allele have resistance to:', 'Malaria', ['Cholera', 'Tuberculosis', 'Measles'], 'This heterozygote advantage maintains the allele in malaria regions such as West Africa.', T.pop);
add('The Hardy-Weinberg equation for genotype frequencies is:', 'p² + 2pq + q² = 1', ['p + q = 2', 'p² − q² = 1', 'pq = 1'], 'With two alleles of frequencies p and q, the genotypes AA, Aa and aa have frequencies p², 2pq and q².', T.pop);
add('In a population in Hardy-Weinberg equilibrium, 16% of individuals show a recessive trait. The frequency of the recessive allele is:', '0.4', ['0.16', '0.6', '0.8'], 'q² = 0.16, so q = 0.4.', T.pop);
chk(Math.sqrt(0.16), 0.4);
add('In the population above (q² = 0.16), the percentage of heterozygotes is:', '48%', ['16%', '24%', '36%'], 'p = 0.6 and q = 0.4, so 2pq = 2 × 0.6 × 0.4 = 0.48.', T.pop);
chk(2 * 0.6 * 0.4, 0.48);
add('Which condition is NOT required for Hardy-Weinberg equilibrium?', 'Natural selection acting on the trait', ['Random mating', 'No mutation', 'A large population with no migration'], 'Selection changes allele frequencies, so its absence is a requirement of equilibrium.', T.pop);

// ---------------- DNA, protein synthesis
add('Who proposed the double helix model of DNA in 1953?', 'Watson and Crick', ['Mendel and Morgan', 'Hershey and Chase', 'Meselson and Stahl'], 'Their model used X-ray diffraction data from Rosalind Franklin and Maurice Wilkins.', T.dna);
add('DNA replication is described as semi-conservative because:', 'Each new DNA molecule has one old strand and one new strand', ['Both strands are new', 'Only half the DNA is copied', 'The old DNA is destroyed'], 'The Meselson-Stahl experiment confirmed this.', T.dna);
add('The enzyme that joins nucleotides to a growing DNA strand during replication is:', 'DNA polymerase', ['RNA polymerase', 'Helicase', 'Ligase only'], 'Helicase unwinds the helix and ligase seals nicks between Okazaki fragments.', T.dna);
add('Transcription is the process in which:', 'An mRNA copy of a gene is made from a DNA template', ['DNA is copied to DNA', 'A protein is made from mRNA', 'RNA is copied into DNA'], 'RNA polymerase makes the mRNA in the nucleus of eukaryotes.', T.dna);
add('A DNA template strand reads 3\' TAC GGA 5\'. The mRNA transcribed from it is:', '5\' AUG CCU 3\'', ['5\' UAC GGA 3\'', '5\' ATG CCT 3\'', '5\' AUG GGA 3\''], 'Complementary pairing gives A-U, T-A, C-G, G-C: TAC gives AUG and GGA gives CCU.', T.dna);
add('Translation takes place at the:', 'Ribosome', ['Nucleolus', 'Golgi apparatus', 'Lysosome'], 'Ribosomes read the mRNA codons and tRNA delivers the matching amino acids.', T.dna);
add('A codon is:', 'A sequence of three nucleotides in mRNA that codes for an amino acid or a stop signal', ['A sequence of three amino acids', 'A part of tRNA that binds the ribosome', 'The enzyme that reads DNA'], 'There are 64 codons and 20 amino acids, so the code is redundant.', T.dna);
add('The start codon, AUG, codes for:', 'Methionine', ['Valine', 'Glycine', 'Proline'], 'Translation usually begins with methionine.', T.dna);
add('An mRNA has 90 nucleotides in its coding region, excluding the stop codon. The number of amino acids in the polypeptide is:', '30', ['90', '270', '3'], 'Three nucleotides code for one amino acid: 90 ÷ 3 = 30.', T.dna);
chk(90 / 3, 30);
add('The anticodon is found on:', 'tRNA', ['mRNA', 'rRNA', 'DNA'], 'It pairs with the mRNA codon during translation.', T.dna);
add('Removal of introns and joining of exons occurs during:', 'RNA processing (splicing) in the nucleus', ['Translation in the cytoplasm', 'DNA replication', 'Transcription termination in bacteria'], 'Eukaryotic mRNA also receives a 5\' cap and a poly-A tail.', T.dna);
add('A mutation in which one base is replaced by another is called a:', 'Point (substitution) mutation', ['Frameshift mutation', 'Translocation', 'Non-disjunction'], 'It may be silent, missense or nonsense, depending on its effect on the codon.', T.mut);
add('Insertion of a single nucleotide into a gene usually causes a frameshift, which:', 'Changes every codon after the insertion', ['Changes only one amino acid', 'Has no effect on the protein', 'Removes the start codon only'], 'The reading frame shifts, so the amino acid sequence is altered from that point on.', T.mut);
add('Which of these is a mutagen?', 'Ultraviolet radiation', ['Visible light', 'Carbon dioxide', 'Oxygen'], 'UV light causes thymine dimers in DNA. X-rays and certain chemicals are also mutagenic.', T.mut);

// ---------------- cell division
add('The stages of mitosis in the correct order are:', 'Prophase, metaphase, anaphase, telophase', ['Metaphase, prophase, telophase, anaphase', 'Prophase, anaphase, metaphase, telophase', 'Telophase, anaphase, metaphase, prophase'], 'Cytokinesis usually follows telophase.', T.mit);
add('During which phase of mitosis do the chromosomes line up along the cell equator?', 'Metaphase', ['Prophase', 'Anaphase', 'Telophase'], 'Spindle fibres attach to the kinetochores of the chromosomes.', T.mit);
add('Sister chromatids separate during:', 'Anaphase', ['Prophase', 'Metaphase', 'Interphase'], 'The centromeres split and chromatids move to opposite poles.', T.mit);
add('A cell with 46 chromosomes undergoes mitosis. Each daughter cell has:', '46 chromosomes', ['23 chromosomes', '92 chromosomes', '69 chromosomes'], 'Mitosis produces genetically identical diploid cells.', T.mit);
add('A human cell with 46 chromosomes undergoes meiosis. Each gamete has:', '23 chromosomes', ['46 chromosomes', '92 chromosomes', '12 chromosomes'], 'Meiosis halves the chromosome number.', T.mei);
add('Meiosis produces:', 'Four genetically different haploid cells', ['Two identical diploid cells', 'Two identical haploid cells', 'Four identical diploid cells'], 'Crossing over and independent assortment create variation.', T.mei);
add('DNA is replicated during the:', 'S phase of interphase', ['G1 phase', 'M phase', 'Cytokinesis'], 'Each chromosome then consists of two sister chromatids.', T.cyc);
add('Uncontrolled cell division that forms a tumour is a feature of:', 'Cancer', ['Meiosis', 'Apoptosis', 'Fertilisation'], 'Mutations in genes controlling the cell cycle, such as oncogenes and tumour suppressors, allow cells to divide without regulation.', T.cyc);
add('Programmed cell death is called:', 'Apoptosis', ['Necrosis', 'Mitosis', 'Cytokinesis'], 'It removes damaged cells and shapes tissues during development.', T.cyc);

// ---------------- photosynthesis and respiration
add('The overall equation for photosynthesis is:', '6CO2 + 6H2O → C6H12O6 + 6O2, using light energy', ['C6H12O6 + 6O2 → 6CO2 + 6H2O', '6O2 + 6H2O → C6H12O6 + 6CO2', '6CO2 + 6O2 → C6H12O6 + 6H2O'], 'Carbon dioxide and water are converted to glucose and oxygen.', T.pho);
add('The light-dependent reactions of photosynthesis take place in the:', 'Thylakoid membranes of the chloroplast', ['Stroma', 'Mitochondrial matrix', 'Cytoplasm'], 'Light energy is used to make ATP and NADPH, and water is split to release oxygen.', T.pho);
add('The Calvin cycle takes place in the:', 'Stroma', ['Thylakoid membrane', 'Cristae', 'Nucleus'], 'The cycle uses ATP and NADPH to fix carbon dioxide into sugar.', T.pho);
add('The oxygen released in photosynthesis comes from:', 'Water', ['Carbon dioxide', 'Glucose', 'Chlorophyll'], 'Photolysis of water at photosystem II releases oxygen.', T.pho);
add('The enzyme that fixes carbon dioxide in the Calvin cycle is:', 'RuBisCO', ['ATP synthase', 'Catalase', 'Amylase'], 'It attaches CO2 to ribulose bisphosphate.', T.pho);
add('Plants look green because chlorophyll:', 'Reflects green light and absorbs mostly red and blue light', ['Absorbs green light', 'Makes green light', 'Transmits red light only'], 'Red and blue wavelengths drive photosynthesis most effectively.', T.pho);
add('Which factor is NOT limiting to the rate of photosynthesis?', 'The concentration of nitrogen gas in the air', ['Light intensity', 'Carbon dioxide concentration', 'Temperature'], 'Nitrogen gas does not take part in photosynthesis.', T.pho);
add('Glycolysis takes place in the:', 'Cytoplasm', ['Mitochondrial matrix', 'Inner mitochondrial membrane', 'Nucleus'], 'It breaks glucose into two molecules of pyruvate and yields a net gain of two ATP.', T.res);
add('The Krebs cycle occurs in the:', 'Mitochondrial matrix', ['Cytoplasm', 'Thylakoid', 'Rough ER'], 'It oxidises acetyl-CoA to CO2 and makes NADH, FADH2 and a little ATP.', T.res);
add('Most ATP in aerobic respiration is produced by:', 'The electron transport chain and oxidative phosphorylation', ['Glycolysis', 'The Krebs cycle', 'Fermentation'], 'Oxygen is the final electron acceptor, and the process yields about 30 to 32 ATP per glucose.', T.res);
add('Fermentation in muscle cells during vigorous exercise produces:', 'Lactic acid', ['Ethanol', 'Acetic acid', 'Carbon dioxide only'], 'Pyruvate is reduced to lactate, which regenerates NAD+ so that glycolysis can continue.', T.res);
add('In yeast, anaerobic respiration produces:', 'Ethanol and carbon dioxide', ['Lactic acid', 'Water and oxygen', 'Glucose'], 'This alcoholic fermentation is used in brewing and baking.', T.res);
add('The net ATP gain from glycolysis of one glucose molecule is:', '2', ['4', '30', '36'], 'Four ATP are produced and two are used in the investment phase.', T.res);

// ---------------- evolution
add('Natural selection acts on:', 'Variation among individuals in a population', ['Individuals that wish to change', 'Acquired characteristics that are passed on', 'Mutations that occur on purpose'], 'Individuals with favourable heritable traits survive and reproduce more.', T.evo);
add('The finches of the Galapagos Islands are important in the study of:', 'Adaptive radiation', ['Antibiotic resistance', 'Convergent evolution of birds and bats', 'Mendelian ratios'], 'A common ancestor gave rise to species with different beak shapes suited to different foods.', T.evo);
add('Lamarck\'s idea that giraffes lengthened their necks by stretching and passed this on is:', 'Inheritance of acquired characteristics, which is not supported by evidence', ['Natural selection', 'Genetic drift', 'Gene flow'], 'Acquired traits do not change the DNA in gametes.', T.evo);
add('Wings of a bat and the arm of a human have the same bone arrangement. These are:', 'Homologous structures', ['Analogous structures', 'Vestigial structures', 'Convergent structures'], 'They show common ancestry and adaptation to different functions.', T.evo);
add('The wings of an insect and the wings of a bird are:', 'Analogous structures', ['Homologous structures', 'Vestigial structures', 'Identical structures'], 'They have similar functions but different structures and origins.', T.evo);
add('The appendix in humans is an example of a:', 'Vestigial structure', ['Analogous structure', 'Adaptive structure of all primates', 'Homologous wing'], 'Vestigial structures have lost most of their original function.', T.evo);
add('The development of antibiotic-resistant bacteria is an example of:', 'Natural selection', ['Use and disuse', 'Spontaneous generation', 'Genetic engineering'], 'Antibiotics kill sensitive cells, so resistant bacteria survive and multiply.', T.evo);
add('Random change in allele frequencies, strongest in small populations, is called:', 'Genetic drift', ['Gene flow', 'Natural selection', 'Mutation pressure'], 'Chance events such as the founder effect and bottlenecks change allele frequencies without regard to fitness.', T.evo);
add('A species is best defined as a group of organisms that:', 'Can interbreed in nature and produce fertile offspring', ['Look the same', 'Live in the same area', 'Have the same number of chromosomes only'], 'This is the biological species concept.', T.evo);
add('Fossils are most commonly found in:', 'Sedimentary rock', ['Igneous rock', 'Metamorphic rock', 'Volcanic ash only'], 'Sediments cover dead organisms slowly and preserve them.', T.evo);

// ---------------- ecology
add('In a food chain, organisms that make their own food are called:', 'Producers', ['Primary consumers', 'Decomposers', 'Tertiary consumers'], 'Green plants and algae are the main producers.', T.eco);
add('In the food chain grass → grasshopper → frog → snake, the frog is a:', 'Secondary consumer', ['Primary consumer', 'Producer', 'Tertiary consumer'], 'The frog eats the grasshopper, which is the primary consumer.', T.eco);
add('Only about 10% of the energy at one trophic level is passed to the next because:', 'Most is lost as heat in respiration and in parts that are not eaten or digested', ['Energy is destroyed', 'Consumers do not need energy', 'Plants store all energy'], 'This limits the number of trophic levels in a food chain.', T.eco);
add('Producers store 10 000 kJ of energy. Using the 10% rule, the energy available to secondary consumers is:', '100 kJ', ['1000 kJ', '10 kJ', '10 000 kJ'], '10 000 × 0.1 = 1000 kJ for primary consumers, and 1000 × 0.1 = 100 kJ for secondary consumers.', T.eco);
chk(10000 * 0.1 * 0.1, 100);
add('A pyramid of biomass is usually upright, but a pyramid of numbers may be inverted when:', 'One large tree supports many insects', ['Producers are many small algae', 'All consumers are carnivores', 'There are no decomposers'], 'The single tree is a large producer for a large number of small consumers.', T.eco);
add('Decomposers such as bacteria and fungi:', 'Break down dead organic matter and return nutrients to the soil', ['Make food by photosynthesis', 'Eat only living plants', 'Remove oxygen from the air'], 'Without them nutrients would stay locked in dead material.', T.eco);
add('A group of organisms of the same species living in the same area is a:', 'Population', ['Community', 'Ecosystem', 'Biome'], 'A community contains all the populations in an area.', T.pop2);
add('The maximum population size an environment can support is its:', 'Carrying capacity', ['Biotic potential', 'Niche', 'Population density'], 'Limited food, space and other resources set this limit.', T.pop2);
add('A population of 200 rabbits lives in a field of 50 hectares. The population density is:', '4 rabbits per hectare', ['10 rabbits per hectare', '0.25 rabbits per hectare', '250 rabbits per hectare'], '200 ÷ 50 = 4.', T.pop2);
chk(200 / 50, 4);
add('A population has 1000 individuals, 150 births and 50 deaths in a year, with no migration. The growth rate is:', '10% per year', ['15% per year', '5% per year', '20% per year'], '(150 − 50) ÷ 1000 = 0.10.', T.pop2);
chk((150 - 50) / 1000, 0.1);
add('Which of the following is a density-dependent limiting factor?', 'Competition for food', ['A flood', 'A volcanic eruption', 'A sudden frost'], 'Density-dependent factors such as competition, disease and predation have more effect as the population becomes dense.', T.pop2);
add('Which relationship benefits both species?', 'Mutualism', ['Parasitism', 'Predation', 'Competition'], 'Examples are nitrogen-fixing bacteria in legume root nodules and mycorrhizae.', T.sym);
add('The tapeworm living in the gut of a human is an example of:', 'Parasitism', ['Commensalism', 'Mutualism', 'Competition'], 'The parasite gains and the host is harmed.', T.sym);
add('In commensalism:', 'One species benefits and the other is neither helped nor harmed', ['Both species are harmed', 'Both species benefit', 'One species benefits and the other is harmed'], 'An example is an epiphyte orchid growing on a tree.', T.sym);
add('Nitrogen-fixing bacteria in the root nodules of legumes convert:', 'Atmospheric nitrogen into ammonia', ['Ammonia into nitrogen gas', 'Nitrate into nitrogen gas', 'Carbon dioxide into sugars'], 'Rhizobium bacteria live in nodules and supply the plant with usable nitrogen.', T.cyc2);
add('The conversion of nitrate to nitrogen gas by bacteria in waterlogged soil is called:', 'Denitrification', ['Nitrification', 'Nitrogen fixation', 'Ammonification'], 'It returns nitrogen to the atmosphere.', T.cyc2);
add('Nitrification is the conversion of:', 'Ammonium to nitrite and then to nitrate', ['Nitrate to nitrogen gas', 'Nitrogen gas to ammonia', 'Proteins to amino acids'], 'Nitrosomonas and Nitrobacter carry out the two steps.', T.cyc2);
add('Carbon dioxide is removed from the atmosphere mainly by:', 'Photosynthesis', ['Respiration', 'Combustion', 'Decomposition'], 'It is returned by respiration, combustion and decay.', T.cyc2);
add('Which gas is mainly responsible for global warming through burning of fossil fuels?', 'Carbon dioxide', ['Oxygen', 'Nitrogen', 'Argon'], 'CO2 traps heat in the atmosphere as a greenhouse gas.', T.eco);
add('The gradual replacement of one community by another over time in an area is called:', 'Ecological succession', ['Adaptive radiation', 'Population growth', 'Biomagnification'], 'Primary succession starts on bare rock, and secondary succession follows a disturbance on soil.', T.eco);
add('The first organisms to colonise bare rock in primary succession are called:', 'Pioneer species, such as lichens', ['Climax species', 'Keystone species', 'Decomposers only'], 'They begin to form soil.', T.eco);
add('The accumulation of a pollutant such as DDT at higher concentrations at each trophic level is called:', 'Biomagnification', ['Eutrophication', 'Succession', 'Nitrification'], 'Top predators have the highest concentrations.', T.eco);
add('Eutrophication of a lake is caused mainly by:', 'Runoff of fertilisers that increases nutrients such as nitrate and phosphate', ['Removal of fish', 'Decrease in rainfall', 'Increase in oxygen'], 'Algae bloom and when they die, decomposition removes oxygen from the water.', T.eco);

// ---------------- human physiology
add('Chemical digestion of starch begins in the mouth with the enzyme:', 'Salivary amylase', ['Pepsin', 'Lipase', 'Trypsin'], 'Amylase breaks starch into maltose.', T.dig);
add('Protein digestion begins in the stomach with:', 'Pepsin in an acidic medium', ['Amylase', 'Lipase', 'Maltase'], 'Hydrochloric acid activates pepsinogen to pepsin.', T.dig);
add('Bile is produced by the liver and helps in:', 'Emulsifying fats', ['Digesting proteins', 'Digesting starch', 'Absorbing water'], 'Bile salts break fat into small droplets, giving lipase a larger surface area.', T.dig);
add('Most absorption of digested food takes place in the:', 'Small intestine, through villi', ['Stomach', 'Large intestine', 'Oesophagus'], 'Villi and microvilli give a large surface area.', T.dig);
add('The main function of the large intestine is to:', 'Absorb water and form faeces', ['Digest proteins', 'Produce bile', 'Absorb most amino acids'], 'Bacteria also make some vitamins.', T.dig);
add('The pancreas secretes enzymes into the:', 'Duodenum', ['Stomach', 'Ileum', 'Oesophagus'], 'It also secretes bicarbonate to neutralise the acidic chyme.', T.dig);
add('Which blood vessels carry blood away from the heart?', 'Arteries', ['Veins', 'Capillaries', 'Venules'], 'Arteries have thick, elastic walls to withstand high pressure.', T.circ);
add('The only artery that carries deoxygenated blood is the:', 'Pulmonary artery', ['Aorta', 'Carotid artery', 'Renal artery'], 'It takes blood from the right ventricle to the lungs.', T.circ);
add('The chamber of the heart that pumps blood into the aorta is the:', 'Left ventricle', ['Right ventricle', 'Left atrium', 'Right atrium'], 'It has the thickest wall because it pumps blood around the whole body.', T.circ);
add('The valve between the left atrium and left ventricle is the:', 'Bicuspid (mitral) valve', ['Tricuspid valve', 'Aortic valve', 'Pulmonary valve'], 'It prevents backflow of blood into the atrium.', T.circ);
add('Red blood cells carry oxygen by means of:', 'Haemoglobin', ['Plasma proteins', 'Fibrinogen', 'Antibodies'], 'Each haemoglobin molecule can bind four oxygen molecules.', T.circ);
add('Platelets are important in:', 'Blood clotting', ['Carrying oxygen', 'Making antibodies', 'Transporting carbon dioxide'], 'They help to seal wounds.', T.circ);
add('A person has a heart rate of 72 beats per minute and a stroke volume of 70 mL. The cardiac output is:', '5040 mL per minute', ['142 mL per minute', '1 mL per minute', '504 mL per minute'], 'Cardiac output = heart rate × stroke volume = 72 × 70 = 5040 mL/min.', T.circ);
chk(72 * 70, 5040);
add('The ABO blood group system is determined by:', 'Antigens on the surface of red blood cells', ['The number of platelets', 'Haemoglobin type', 'Plasma volume'], 'Group A has A antigens, B has B antigens, AB has both, and O has neither.', T.circ);
add('People of blood group O are called universal donors because their red cells:', 'Have no A or B antigens', ['Have both A and B antigens', 'Have no Rh factor and no plasma', 'Contain more haemoglobin'], 'Recipients have no antibodies that react to the cells.', T.circ);
add('Gas exchange in the lungs takes place in the:', 'Alveoli', ['Bronchi', 'Trachea', 'Bronchioles'], 'Alveoli have thin walls and a rich blood supply.', T.resp);
add('During inhalation the diaphragm:', 'Contracts and flattens, increasing the volume of the chest cavity', ['Relaxes and moves upwards', 'Contracts and moves upwards', 'Stays still'], 'The pressure inside the lungs falls below atmospheric pressure and air enters.', T.resp);
add('Most carbon dioxide is transported in the blood as:', 'Bicarbonate ions', ['Dissolved CO2', 'Carbaminohaemoglobin', 'Carbon monoxide'], 'Carbonic anhydrase in red blood cells speeds the conversion.', T.resp);
add('Carbon monoxide is dangerous because it:', 'Binds to haemoglobin more strongly than oxygen does', ['Dissolves in plasma', 'Destroys alveoli', 'Stops the heart directly'], 'It reduces the oxygen-carrying capacity of the blood.', T.resp);
add('The functional unit of the kidney is the:', 'Nephron', ['Neuron', 'Alveolus', 'Villus'], 'Each kidney has about one million nephrons.', T.exc);
add('Ultrafiltration in the kidney occurs in the:', 'Glomerulus and Bowman\'s capsule', ['Loop of Henle', 'Collecting duct', 'Bladder'], 'High pressure forces water, glucose, salts and urea into the capsule, but not blood cells or large proteins.', T.exc);
add('Glucose is normally absent from urine because it is:', 'Reabsorbed in the proximal convoluted tubule', ['Not filtered', 'Broken down in the bladder', 'Secreted into the collecting duct'], 'Glucose in urine suggests diabetes mellitus.', T.exc);
add('The hormone ADH acts on the kidney to:', 'Increase reabsorption of water in the collecting duct', ['Increase excretion of water', 'Increase excretion of glucose', 'Decrease reabsorption of sodium'], 'It is released by the posterior pituitary when the blood is too concentrated.', T.exc);
add('The main nitrogenous waste of humans is:', 'Urea', ['Uric acid', 'Ammonia', 'Creatinine only'], 'It is made in the liver from the deamination of amino acids.', T.exc);
add('Insulin is produced by the:', 'Beta cells of the islets of Langerhans in the pancreas', ['Liver', 'Adrenal gland', 'Thyroid'], 'It lowers blood glucose.', T.hor);
add('Glucagon raises blood glucose by:', 'Stimulating the breakdown of glycogen in the liver', ['Stimulating glycogen synthesis', 'Reducing glucose absorption in the gut only', 'Destroying insulin'], 'It is released from alpha cells when blood glucose is low.', T.hor);
add('Diabetes mellitus type 1 results from:', 'Failure of the pancreas to produce enough insulin', ['Too much insulin', 'Failure of the kidney to filter blood', 'Lack of thyroxine'], 'Type 2 involves insulin resistance of the cells.', T.hor);
add('Thyroxine, produced by the thyroid gland, regulates:', 'Metabolic rate', ['Blood clotting', 'Urine volume', 'Milk production'], 'Iodine is needed to make it, and deficiency can cause goitre.', T.hor);
add('The "fight or flight" hormone is:', 'Adrenaline', ['Insulin', 'Oestrogen', 'Thyroxine'], 'It is released by the adrenal medulla and raises heart rate and blood glucose.', T.hor);
add('The pituitary gland is sometimes called the master gland because it:', 'Secretes hormones that control other endocrine glands', ['Is the largest gland', 'Makes insulin', 'Controls digestion'], 'It is itself controlled by the hypothalamus.', T.hor);
add('Negative feedback:', 'Reverses a change to keep a variable near its set point', ['Increases a change until a limit is reached', 'Stops all regulation', 'Occurs only in plants'], 'Control of body temperature and blood glucose are examples.', T.hor);
add('The part of a neuron that receives signals from other neurons is the:', 'Dendrite', ['Axon terminal', 'Myelin sheath', 'Synaptic cleft'], 'The axon carries the impulse away from the cell body.', T.nerv);
add('At a chemical synapse, the impulse crosses the gap by means of:', 'A neurotransmitter', ['A hormone from the pituitary', 'Electrons', 'Myelin'], 'Acetylcholine is released from vesicles and binds to receptors on the next cell.', T.nerv);
add('The resting membrane potential of a neuron is about:', '-70 mV', ['+70 mV', '0 mV', '+30 mV'], 'The inside of the cell is negative relative to the outside.', T.nerv);
add('The myelin sheath speeds up the transmission of nerve impulses by:', 'Allowing the impulse to jump between nodes of Ranvier', ['Making the axon thicker', 'Producing neurotransmitters', 'Carrying the impulse chemically'], 'This is saltatory conduction.', T.nerv);
add('A reflex action is:', 'A rapid, involuntary response to a stimulus', ['A voluntary action that is learnt', 'A slow response controlled by the cerebrum', 'A response that needs hormones only'], 'The impulse passes through a reflex arc of receptor, sensory neuron, relay neuron, motor neuron and effector.', T.nerv);
add('The part of the brain that controls balance and coordination of movement is the:', 'Cerebellum', ['Cerebrum', 'Medulla oblongata', 'Hypothalamus'], 'The medulla controls breathing and heart rate.', T.nerv);
add('The part of the brain that regulates body temperature and thirst is the:', 'Hypothalamus', ['Cerebellum', 'Cerebrum', 'Medulla oblongata'], 'It acts as the thermostat of the body.', T.nerv);

// ---------------- reproduction, immunity, plant hormones, biotechnology
add('Fertilisation in humans normally takes place in the:', 'Fallopian tube (oviduct)', ['Uterus', 'Ovary', 'Vagina'], 'The zygote then travels to the uterus and implants.', T.rep);
add('Sperm are produced in the:', 'Seminiferous tubules of the testes', ['Prostate gland', 'Epididymis only', 'Vas deferens'], 'They mature and are stored in the epididymis.', T.rep);
add('Ovulation is triggered by a surge of:', 'Luteinising hormone', ['Progesterone', 'Insulin', 'Testosterone'], 'The egg is released from the Graafian follicle around day 14 of a 28-day cycle.', T.rep);
add('The hormone that maintains the uterine lining during pregnancy is:', 'Progesterone', ['FSH', 'Insulin', 'Thyroxine'], 'It is first secreted by the corpus luteum and later by the placenta.', T.rep);
add('The placenta allows exchange of materials between mother and foetus but:', 'Keeps their blood separate', ['Mixes their blood completely', 'Prevents the passage of oxygen', 'Is formed only after birth'], 'Exchange is by diffusion and active transport across the placental membrane.', T.rep);
add('Antibodies are produced by:', 'B lymphocytes (plasma cells)', ['Red blood cells', 'Platelets', 'Neutrophils'], 'Each antibody is specific to one antigen.', T.imm);
add('Vaccination works by:', 'Stimulating the body to make memory cells without causing the disease', ['Giving antibodies from another person', 'Killing all bacteria in the body', 'Making the skin thicker'], 'On later infection, memory cells give a faster and stronger response.', T.imm);
add('HIV infects and destroys:', 'Helper T cells', ['Red blood cells', 'Platelets', 'Neurons'], 'Loss of these cells weakens the immune system and leads to AIDS.', T.imm);
add('The plant hormone responsible for phototropism is:', 'Auxin', ['Gibberellin', 'Ethylene', 'Abscisic acid'], 'Auxin accumulates on the shaded side of the shoot and stimulates cell elongation there.', T.plant);
add('Ripening of fruits is promoted by:', 'Ethylene', ['Auxin', 'Cytokinin', 'Gibberellin'], 'Ethylene is a gas, and a ripe fruit can cause nearby fruits to ripen.', T.plant);
add('Seed germination and stem elongation are promoted by:', 'Gibberellins', ['Abscisic acid', 'Ethylene', 'Auxin only'], 'Gibberellins stimulate the production of amylase in germinating cereal grains.', T.plant);
add('Abscisic acid:', 'Promotes seed dormancy and closure of stomata under water stress', ['Promotes fruit ripening', 'Breaks seed dormancy', 'Stimulates cell division'], 'It acts as a stress hormone.', T.plant);
add('Restriction enzymes are used in genetic engineering to:', 'Cut DNA at specific base sequences', ['Join DNA fragments', 'Copy DNA', 'Translate mRNA'], 'DNA ligase is then used to join the fragments.', T.bt);
add('A plasmid is used as a vector because it:', 'Can carry a foreign gene into a bacterial cell and replicate', ['Contains the nucleus', 'Digests DNA', 'Makes antibodies'], 'It is a small circular DNA molecule separate from the main chromosome.', T.bt);
add('Human insulin for the treatment of diabetes is now made by:', 'Genetically modified bacteria', ['Pigs only', 'Extracting it from human blood', 'Viruses'], 'The human insulin gene is inserted into a plasmid in Escherichia coli.', T.bt);
add('The polymerase chain reaction (PCR) is used to:', 'Make many copies of a specific DNA sequence', ['Separate proteins', 'Cut DNA', 'Sequence amino acids'], 'Cycles of heating and cooling with Taq polymerase double the DNA each cycle.', T.bt);
add('In gel electrophoresis, DNA fragments move towards the positive electrode because:', 'DNA is negatively charged', ['DNA is positively charged', 'DNA is neutral', 'The gel is acidic'], 'Smaller fragments move faster and farther through the gel.', T.bt);

module.exports = out;
