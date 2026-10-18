// BIO 101 batch 2 - hand-set from OpenStax Biology 2e and Concepts of Biology. Medium difficulty.
const L = require('../sta/lib');
const { add, out } = L;
const T = {
  live: 'Characteristics of Living Things', cell: 'The Cell Concept', euk: 'Eukaryotic Cell Structure', mic: 'Microbial Classification', fun: 'Fungi', alg: 'Algae', pro: 'Protozoa', vir: 'Viruses',
  bry: 'Bryophytes', pter: 'Pteridophytes', sperm: 'Spermatophyta', ptis: 'Plant Tissues', ani: 'Animal Taxonomy', atis: 'Animal Tissues', ph: 'pH, Buffers and Membrane Transport', org: 'Hydrocarbons and Organic Compounds', carb: 'Carbohydrates', mol: 'Biological Macromolecules',
};

// ---------------- cell concept and organelles
add('Which statement belongs to the cell theory?', 'All living things are made of one or more cells, and new cells arise from existing cells', ['Cells arise by spontaneous generation from non-living matter', 'Only plants and fungi are made of cells', 'The nucleus is present in every cell'], 'The cell theory states that all organisms are composed of cells, the cell is the basic unit of life, and cells come only from pre-existing cells.', T.cell);
add('Which scientist first described cells while examining thin slices of cork?', 'Robert Hooke', ['Antonie van Leeuwenhoek', 'Matthias Schleiden', 'Rudolf Virchow'], 'Hooke observed the box-like compartments of cork in 1665 and called them cells. Leeuwenhoek later observed living microorganisms.', T.cell);
add('Rudolf Virchow is remembered in the cell theory for the idea that:', 'All cells come from pre-existing cells', ['All plants are made of cells', 'All animals are made of cells', 'Cells contain a nucleus'], 'Virchow\'s statement that every cell comes from a cell replaced the older idea of spontaneous generation.', T.cell);
add('Which feature is found in prokaryotic cells but NOT in eukaryotic cells?', 'A nucleoid region with a single circular chromosome and no nuclear envelope', ['A plasma membrane', 'Ribosomes', 'Cytoplasm'], 'Prokaryotes have their DNA in a nucleoid that is not surrounded by a membrane. All cells have a plasma membrane, cytoplasm and ribosomes.', T.cell);
add('Why do most cells remain small?', 'Their surface area to volume ratio falls as they grow, which limits exchange of materials', ['Large cells cannot contain DNA', 'Cell membranes cannot be stretched at all', 'Small cells do not need energy'], 'As a cell grows, volume increases faster than surface area, so diffusion across the membrane can no longer supply the whole cell.', T.cell);
add('A cube-shaped cell has sides of 2 µm. Its surface area to volume ratio is:', '3 : 1', ['1 : 3', '6 : 1', '2 : 1'], 'Surface area = 6 × 2² = 24 µm². Volume = 2³ = 8 µm³. The ratio is 24 : 8 = 3 : 1.', T.cell);
add('The organelle in which most of the cell\'s ATP is produced by aerobic respiration is the:', 'Mitochondrion', ['Golgi apparatus', 'Lysosome', 'Rough endoplasmic reticulum'], 'The inner mitochondrial membrane carries the electron transport chain and ATP synthase.', T.euk);
add('Ribosomes are the site of:', 'Protein synthesis', ['Lipid storage', 'Photosynthesis', 'DNA replication'], 'Ribosomes, made of rRNA and protein, translate mRNA into polypeptides.', T.euk);
add('Which organelle modifies, sorts and packages proteins and lipids for secretion or delivery to other organelles?', 'Golgi apparatus', ['Nucleolus', 'Peroxisome', 'Central vacuole'], 'Vesicles from the ER fuse with the cis face of the Golgi, and finished products leave from the trans face.', T.euk);
add('Cells that secrete large amounts of protein, such as those of the pancreas that make digestive enzymes, would be expected to have a well-developed:', 'Rough endoplasmic reticulum', ['Smooth endoplasmic reticulum only', 'Cell wall', 'Chloroplast'], 'Ribosomes on the rough ER make proteins destined for secretion.', T.euk);
add('The smooth endoplasmic reticulum is mainly involved in:', 'Lipid synthesis and detoxification of drugs and poisons', ['Synthesis of secretory proteins', 'Packaging of DNA', 'Production of ribosomal subunits'], 'Smooth ER lacks ribosomes and makes phospholipids and steroids, and its enzymes detoxify many compounds in liver cells.', T.euk);
add('Lysosomes contain:', 'Hydrolytic enzymes that digest macromolecules, worn-out organelles and engulfed particles', ['Chlorophyll', 'DNA polymerase', 'Starch grains'], 'Lysosomal enzymes work best at an acidic pH of about 5.', T.euk);
add('Which organelle is found in plant cells but not in animal cells?', 'Chloroplast', ['Mitochondrion', 'Ribosome', 'Nucleus'], 'Chloroplasts carry out photosynthesis. Animal cells have no chloroplasts, no cell wall and no large central vacuole.', T.euk);
add('The cell wall of plant cells is made mainly of:', 'Cellulose', ['Chitin', 'Peptidoglycan', 'Glycogen'], 'Cellulose microfibrils give plant cell walls strength. Chitin is found in fungal walls and peptidoglycan in bacterial walls.', T.euk);
add('The function of the central vacuole of a mature plant cell is to:', 'Store water and solutes and maintain turgor pressure', ['Make ATP', 'Replicate DNA', 'Synthesise proteins'], 'The vacuole fills with water and pushes the membrane against the wall, keeping the cell turgid.', T.euk);
add('The fluid mosaic model describes the plasma membrane as:', 'A phospholipid bilayer in which proteins are embedded and can move laterally', ['A rigid layer of protein with lipid on the outside', 'A single layer of phospholipid', 'A layer of cellulose and protein'], 'Phospholipids and proteins move within the plane of the membrane, giving it a fluid, mosaic structure.', T.euk);
add('In the cell membrane, the hydrophobic tails of phospholipids face:', 'Each other, towards the interior of the bilayer', ['The cytoplasm', 'The extracellular fluid', 'The nucleus'], 'The hydrophilic heads face the watery environments on both sides, and the fatty acid tails are hidden in the middle.', T.euk);
add('Cholesterol in animal cell membranes helps to:', 'Stabilise membrane fluidity over a range of temperatures', ['Pump sodium ions out of the cell', 'Make ATP', 'Join cells together'], 'At high temperature cholesterol restrains movement of phospholipids, and at low temperature it prevents them packing tightly.', T.euk);
add('The nucleolus is the region of the nucleus where:', 'Ribosomal RNA is made and ribosomal subunits are assembled', ['Lysosomes are formed', 'Proteins are packaged', 'ATP is produced'], 'rRNA genes are transcribed in the nucleolus and combined with proteins imported from the cytoplasm.', T.euk);
add('The cytoskeleton fibres made of the protein tubulin are the:', 'Microtubules', ['Microfilaments', 'Intermediate filaments', 'Cell wall fibres'], 'Microtubules form the spindle, cilia and flagella. Microfilaments are made of actin.', T.euk);
add('Cilia and flagella of eukaryotic cells have a "9 + 2" arrangement of:', 'Microtubules', ['Actin filaments', 'Ribosomes', 'Cellulose fibres'], 'Nine doublets surround a central pair of microtubules.', T.euk);
add('Which structure allows direct passage of water and small molecules between adjacent plant cells?', 'Plasmodesmata', ['Desmosomes', 'Tight junctions', 'Gap junction proteins found only in fungi'], 'Plasmodesmata are channels through the cell walls linking the cytoplasm of neighbouring plant cells.', T.euk);
add('The endosymbiotic theory proposes that mitochondria and chloroplasts originated from:', 'Prokaryotes that were engulfed by an ancestral cell', ['Fragments of the nucleus', 'Viruses that infected the first cell', 'Vesicles of the Golgi apparatus'], 'Both organelles have their own circular DNA, 70S ribosomes and double membranes, which fits their bacterial origin.', T.euk);

// ---------------- membrane transport
add('Movement of oxygen from the alveoli into the blood across a membrane is by:', 'Simple diffusion', ['Active transport', 'Endocytosis', 'Facilitated diffusion using carrier ATP'], 'Small non-polar molecules cross the bilayer down their concentration gradient without energy or carriers.', T.ph);
add('Osmosis is the movement of:', 'Water across a selectively permeable membrane from lower solute concentration to higher solute concentration', ['Solute from low to high concentration', 'Water from high solute concentration to low solute concentration', 'Ions using ATP'], 'Water moves towards the region with the lower water potential, that is, the more concentrated solution.', T.ph);
add('A red blood cell placed in distilled water will:', 'Swell and may burst', ['Shrink', 'Stay the same size', 'Divide'], 'Water enters the cell by osmosis because the cytoplasm is hypertonic to pure water. Animal cells have no wall to resist this.', T.ph);
add('A plant cell placed in a strong salt solution loses water and its membrane pulls away from the wall. This is called:', 'Plasmolysis', ['Turgor', 'Lysis', 'Imbibition'], 'The protoplast shrinks because the external solution is hypertonic.', T.ph);
add('Which process requires a carrier protein but NOT metabolic energy?', 'Facilitated diffusion', ['Sodium-potassium pump', 'Exocytosis', 'Phagocytosis'], 'Facilitated diffusion moves molecules such as glucose down a gradient through channels or carriers.', T.ph);
add('The sodium-potassium pump moves:', 'Three sodium ions out and two potassium ions in per ATP used', ['Two sodium ions out and three potassium ions in', 'Sodium and potassium both out of the cell', 'Sodium and potassium both into the cell'], 'This active transport maintains the electrochemical gradient needed by nerve and muscle cells.', T.ph);
add('White blood cells engulf bacteria by:', 'Phagocytosis', ['Pinocytosis of solutes only', 'Facilitated diffusion', 'Osmosis'], 'Phagocytosis is a form of endocytosis in which the membrane surrounds a large particle and forms a vacuole.', T.ph);
add('Secretion of insulin by pancreatic cells into the blood occurs by:', 'Exocytosis', ['Endocytosis', 'Osmosis', 'Simple diffusion'], 'Secretory vesicles fuse with the plasma membrane and release their contents outside the cell.', T.ph);
add('A buffer solution:', 'Resists a change in pH when small amounts of acid or base are added', ['Always has a pH of 7', 'Has no hydrogen ions', 'Raises the pH of any solution'], 'A buffer contains a weak acid and its conjugate base which neutralise added H+ or OH-.', T.ph);
add('The main buffer system of human blood is:', 'Carbonic acid and bicarbonate', ['Acetic acid and acetate', 'Hydrochloric acid and chloride', 'Sodium and potassium'], 'CO2 combines with water to form carbonic acid, which dissociates to bicarbonate and H+. This keeps blood pH close to 7.4.', T.ph);
add('A solution of pH 4 has how many times more hydrogen ions than a solution of pH 6?', '100 times', ['2 times', '10 times', '1000 times'], 'pH is logarithmic. A difference of two pH units is a hundredfold difference in [H+].', T.ph);

// ---------------- biological macromolecules
add('Which bond links two amino acids in a polypeptide?', 'Peptide bond', ['Glycosidic bond', 'Ester bond', 'Hydrogen bond'], 'A peptide bond forms between the carboxyl group of one amino acid and the amino group of the next, releasing water.', T.mol);
add('Which level of protein structure is the order of amino acids in the chain?', 'Primary structure', ['Secondary structure', 'Tertiary structure', 'Quaternary structure'], 'The primary structure is the amino acid sequence. Alpha helices and beta sheets are secondary structure.', T.mol);
add('Triglycerides are formed from:', 'One glycerol and three fatty acids', ['Three glycerol and one fatty acid', 'Glycerol and three amino acids', 'Three monosaccharides'], 'Three ester bonds join the fatty acids to glycerol.', T.mol);
add('Unsaturated fatty acids differ from saturated fatty acids in having:', 'One or more double bonds between carbon atoms', ['No carbon atoms', 'A phosphate group', 'A nitrogen-containing base'], 'The double bonds cause kinks, so unsaturated fats such as plant oils are usually liquid at room temperature.', T.mol);
add('Which lipid is the main component of cell membranes?', 'Phospholipid', ['Triglyceride', 'Wax', 'Steroid hormone'], 'Phospholipids have a polar head and two non-polar tails.', T.mol);
add('The monomers of nucleic acids are:', 'Nucleotides', ['Amino acids', 'Monosaccharides', 'Fatty acids'], 'Each nucleotide has a phosphate, a pentose sugar and a nitrogenous base.', T.mol);
add('Which base is found in RNA but not in DNA?', 'Uracil', ['Thymine', 'Adenine', 'Cytosine'], 'RNA uses uracil in place of thymine.', T.mol);
add('In DNA, adenine pairs with:', 'Thymine through two hydrogen bonds', ['Cytosine through two hydrogen bonds', 'Guanine through three hydrogen bonds', 'Uracil through three hydrogen bonds'], 'A pairs with T by two hydrogen bonds, and G pairs with C by three.', T.mol);
add('An enzyme speeds up a reaction by:', 'Lowering the activation energy', ['Raising the temperature of the reaction', 'Being used up in the reaction', 'Changing the equilibrium of the reaction'], 'Enzymes provide an alternative pathway with lower activation energy and are not consumed.', T.mol);
add('A sample of DNA contains 20% adenine. The percentage of guanine is:', '30%', ['20%', '40%', '60%'], 'A = T = 20%, so A + T = 40%. The remaining 60% is shared equally between G and C, so G = 30%.', T.mol);

// ---------------- carbohydrates and organic compounds
add('Which is a disaccharide?', 'Maltose', ['Glucose', 'Fructose', 'Cellulose'], 'Maltose consists of two glucose units. Glucose and fructose are monosaccharides and cellulose is a polysaccharide.', T.carb);
add('Sucrose is formed from:', 'Glucose and fructose', ['Two molecules of glucose', 'Glucose and galactose', 'Two molecules of fructose'], 'Condensation of glucose and fructose gives sucrose, table sugar.', T.carb);
add('Lactose, the sugar in milk, is made of glucose and:', 'Galactose', ['Fructose', 'Ribose', 'Maltose'], 'Lactose is hydrolysed by lactase.', T.carb);
add('The chemical reaction that joins two monosaccharides into a disaccharide and releases water is:', 'Condensation (dehydration synthesis)', ['Hydrolysis', 'Oxidation', 'Neutralisation'], 'A glycosidic bond forms as a molecule of water is removed.', T.carb);
add('Cellulose and starch are both polymers of glucose, yet humans digest starch and not cellulose. This is because:', 'The glucose units are linked differently and human enzymes cannot break the beta linkages of cellulose', ['Cellulose contains fructose', 'Starch has no glycosidic bonds', 'Cellulose is a protein'], 'Starch has alpha 1,4 linkages and cellulose has beta 1,4 linkages.', T.carb);
add('Benedict\'s solution is heated with a sugar solution and a brick-red precipitate forms. This shows that the sugar is:', 'A reducing sugar', ['A non-reducing sugar', 'Starch', 'A protein'], 'Reducing sugars reduce copper(II) ions to red copper(I) oxide.', T.carb);
add('The simplest alkane is:', 'Methane', ['Ethene', 'Ethyne', 'Propane'], 'Methane, CH4, has a single carbon atom.', T.org);
add('Which hydrocarbon contains a carbon-carbon triple bond?', 'Ethyne', ['Ethane', 'Ethene', 'Propane'], 'Alkynes have the general formula CnH2n-2.', T.org);
add('The functional group -COOH is characteristic of:', 'Carboxylic acids', ['Alcohols', 'Aldehydes', 'Ketones'], 'The carboxyl group gives amino acids and fatty acids their acidic properties.', T.org);
add('The general formula of the alkenes is:', 'CnH2n', ['CnH2n+2', 'CnH2n-2', 'CnHn'], 'Alkenes have one double bond, so they have two fewer hydrogens than the alkane with the same number of carbons.', T.org);

// ---------------- microbes
add('The three domains of life are:', 'Bacteria, Archaea and Eukarya', ['Plantae, Animalia and Fungi', 'Prokaryota, Protista and Monera', 'Bacteria, Viruses and Eukarya'], 'Carl Woese proposed the domains from comparisons of ribosomal RNA sequences.', T.mic);
add('Which kingdom in Whittaker\'s five-kingdom system contains unicellular eukaryotes?', 'Protista', ['Monera', 'Fungi', 'Plantae'], 'Monera contained the prokaryotes. Protista included algae and protozoa.', T.mic);
add('Which of these is an archaeon habitat?', 'Boiling hot springs', ['Only the human gut wall', 'Only fresh milk', 'Only soil in cool climates'], 'Many archaea are extremophiles living in hot, salty or acidic environments.', T.mic);
add('Gram-positive bacteria stain purple because they have:', 'A thick layer of peptidoglycan in the cell wall', ['No cell wall', 'An outer lipopolysaccharide membrane', 'A nucleus'], 'The thick peptidoglycan wall retains the crystal violet stain after alcohol treatment.', T.mic);
add('Bacteria that are spiral in shape are called:', 'Spirilla', ['Cocci', 'Bacilli', 'Vibrios only'], 'Cocci are spherical and bacilli are rod-shaped.', T.mic);
add('Binary fission in bacteria is:', 'A type of asexual reproduction in which the cell divides into two identical cells', ['Sexual reproduction with meiosis', 'Budding with unequal cells', 'A form of conjugation'], 'The circular chromosome is replicated and the cell splits.', T.mic);
add('Transfer of DNA between two bacteria through a pilus is called:', 'Conjugation', ['Transformation', 'Transduction', 'Binary fission'], 'Conjugation passes plasmid DNA from donor to recipient cell.', T.mic);
add('Cyanobacteria are important because they:', 'Carry out photosynthesis and some fix atmospheric nitrogen', ['Cause most human diseases', 'Digest cellulose', 'Are all parasites'], 'They contributed oxygen to the early atmosphere and are common in water and soil.', T.mic);

// ---------------- viruses
add('A virus is classified as non-living by many biologists because it:', 'Cannot reproduce or carry out metabolism outside a host cell', ['Has no genetic material', 'Is larger than a bacterium', 'Has no protein'], 'Viruses lack cellular structure and use the host\'s machinery to replicate.', T.vir);
add('The protein coat of a virus is the:', 'Capsid', ['Envelope', 'Plasmid', 'Pilus'], 'The capsid is made of protein subunits called capsomeres and encloses the nucleic acid.', T.vir);
add('Bacteriophages are viruses that infect:', 'Bacteria', ['Plants', 'Fungi', 'Animals'], 'Phages attach to bacterial cells and inject their DNA.', T.vir);
add('In the lytic cycle, a bacteriophage:', 'Replicates in the host and destroys it to release new virions', ['Integrates into the host chromosome and stays dormant', 'Never enters the host', 'Produces spores'], 'In the lysogenic cycle, the viral DNA integrates into the host chromosome as a prophage.', T.vir);
add('HIV is a retrovirus because it:', 'Uses reverse transcriptase to make DNA from its RNA genome', ['Has a DNA genome', 'Infects only bacteria', 'Makes proteins without a host'], 'The DNA copy integrates into the host genome.', T.vir);
add('Which disease is caused by a virus?', 'Measles', ['Tuberculosis', 'Malaria', 'Cholera'], 'Tuberculosis and cholera are bacterial and malaria is caused by a protozoan, Plasmodium.', T.vir);

// ---------------- fungi
add('The cell walls of fungi contain:', 'Chitin', ['Cellulose', 'Peptidoglycan', 'Lignin'], 'Chitin is also found in the exoskeleton of arthropods.', T.fun);
add('Fungi obtain nutrients by:', 'Secreting enzymes and absorbing the digested products', ['Photosynthesis', 'Ingesting food particles by phagocytosis', 'Chemosynthesis'], 'Fungi are heterotrophic absorbers, many of them saprophytes.', T.fun);
add('The body of a mould is made of thread-like filaments called:', 'Hyphae', ['Rhizoids', 'Thalli', 'Fronds'], 'A network of hyphae forms the mycelium.', T.fun);
add('Yeast, used in baking, is a:', 'Unicellular fungus that reproduces mainly by budding', ['Bacterium', 'Alga', 'Protozoan'], 'Saccharomyces cerevisiae ferments sugar to ethanol and carbon dioxide, which makes dough rise.', T.fun);
add('Mushrooms such as Agaricus belong to the group:', 'Basidiomycota', ['Zygomycota', 'Ascomycota', 'Chytridiomycota'], 'Basidiomycetes produce spores on club-shaped basidia.', T.fun);
add('Bread mould, Rhizopus, belongs to the:', 'Zygomycota', ['Basidiomycota', 'Ascomycota', 'Deuteromycota only'], 'Zygomycetes form a zygospore during sexual reproduction.', T.fun);
add('A lichen is a symbiotic association of a fungus and:', 'An alga or cyanobacterium', ['A moss', 'A fern', 'A protozoan'], 'The photosynthetic partner supplies food and the fungus gives protection and absorbs water.', T.fun);
add('A mycorrhiza is an association between fungi and:', 'The roots of plants', ['The leaves of ferns', 'Animal skin', 'Algae in lichens'], 'The fungus increases absorption of water and minerals and receives sugars from the plant.', T.fun);
add('Penicillin was discovered from the fungus:', 'Penicillium', ['Rhizopus', 'Agaricus', 'Candida'], 'Alexander Fleming noticed that Penicillium mould inhibited bacterial growth.', T.fun);

// ---------------- algae
add('Photosynthetic pigments of green algae (Chlorophyta) are:', 'Chlorophyll a and b', ['Chlorophyll a and fucoxanthin', 'Phycoerythrin only', 'Bacteriochlorophyll'], 'Green algae share their pigments and cellulose walls with land plants, so they are considered the closest relatives of plants.', T.alg);
add('Brown algae such as kelp get their colour from the pigment:', 'Fucoxanthin', ['Phycocyanin', 'Chlorophyll b', 'Carotene only'], 'Phaeophyta include the large seaweeds Laminaria and Fucus.', T.alg);
add('Red algae owe their colour to:', 'Phycoerythrin', ['Fucoxanthin', 'Chlorophyll b', 'Xanthophyll only'], 'Phycoerythrin absorbs blue light and lets red algae live at greater depths.', T.alg);
add('Diatoms have cell walls made of:', 'Silica', ['Cellulose only', 'Chitin', 'Calcium carbonate only'], 'The silica shells are called frustules.', T.alg);
add('Spirogyra is a green alga known for its:', 'Spiral chloroplasts in filamentous cells', ['Gas-filled bladders', 'Silica shells', 'Pigment phycoerythrin'], 'It reproduces sexually by conjugation.', T.alg);
add('Algae are important in aquatic ecosystems because they:', 'Act as primary producers at the base of the food chain', ['Break down dead animals', 'Are the main parasites of fish', 'Make nitrogen gas'], 'Phytoplankton produce much of the oxygen and organic matter of aquatic environments.', T.alg);

// ---------------- protozoa
add('Amoeba moves and feeds by means of:', 'Pseudopodia', ['Cilia', 'Flagella', 'A tail fin'], 'Pseudopodia are temporary extensions of cytoplasm that engulf food.', T.pro);
add('Paramecium moves using:', 'Cilia', ['Pseudopodia', 'A single flagellum', 'Muscles'], 'It is a ciliate with an oral groove and contractile vacuoles.', T.pro);
add('The contractile vacuole of freshwater protozoa:', 'Expels excess water that enters by osmosis', ['Digests food', 'Stores starch', 'Makes ATP'], 'The cytoplasm is hypertonic to fresh water, so water continually enters.', T.pro);
add('Malaria is caused by:', 'A protozoan of the genus Plasmodium transmitted by female Anopheles mosquitoes', ['A virus carried by Aedes mosquitoes', 'A bacterium spread in water', 'A fungus in soil'], 'Plasmodium infects liver cells and then red blood cells.', T.pro);
add('Trypanosoma brucei, the cause of sleeping sickness, is spread by:', 'The tsetse fly', ['The Anopheles mosquito', 'The housefly', 'Ticks'], 'It is a flagellate protozoan living in the blood.', T.pro);
add('Euglena is unusual because it:', 'Has chloroplasts and can also feed heterotrophically', ['Has no nucleus', 'Is a bacterium', 'Is a multicellular alga'], 'It has a flagellum and an eyespot for locating light.', T.pro);

// ---------------- bryophytes, pteridophytes, seed plants
add('In bryophytes the dominant, conspicuous generation is the:', 'Gametophyte', ['Sporophyte', 'Zygote', 'Prothallus of a fern'], 'The moss plant is haploid and the sporophyte depends on it for nutrition.', T.bry);
add('Mosses are anchored to the substrate by:', 'Rhizoids', ['True roots', 'Tap roots', 'Adventitious roots'], 'Bryophytes lack true roots, stems and leaves, and have no vascular tissue.', T.bry);
add('Bryophytes need water for reproduction because:', 'The sperm are flagellated and swim to the egg', ['They have no sperm', 'Their seeds need water to germinate', 'Their leaves absorb water only'], 'This restricts them to moist habitats.', T.bry);
add('Liverworts, hornworts and mosses together make up the:', 'Bryophytes', ['Pteridophytes', 'Gymnosperms', 'Angiosperms'], 'They are non-vascular land plants.', T.bry);
add('In ferns the dominant generation is the:', 'Sporophyte', ['Gametophyte', 'Gamete', 'Protonema'], 'The leafy fern plant is diploid, and the small heart-shaped prothallus is the gametophyte.', T.pter);
add('Clusters of sporangia on the underside of a fern frond are called:', 'Sori', ['Archegonia', 'Cones', 'Fruits'], 'Sori release haploid spores that grow into prothalli.', T.pter);
add('Pteridophytes are more advanced than bryophytes because they have:', 'Xylem and phloem', ['Seeds', 'Flowers', 'Pollen tubes'], 'Vascular tissue allows them to grow taller and have true roots, stems and leaves.', T.pter);
add('Which of these is a gymnosperm?', 'Pine', ['Maize', 'Fern', 'Mango'], 'Gymnosperms have naked seeds borne on cone scales.', T.sperm);
add('The seeds of angiosperms are enclosed in:', 'Fruits developed from the ovary', ['Cones', 'Sori', 'Spore cases'], 'The ovary wall becomes the fruit after fertilisation.', T.sperm);
add('A plant with parallel-veined leaves, scattered vascular bundles and flower parts in threes is probably a:', 'Monocotyledon', ['Dicotyledon', 'Gymnosperm', 'Bryophyte'], 'Maize, rice and grasses are monocots.', T.sperm);
add('Dicotyledons typically have:', 'Two cotyledons, net-veined leaves and a tap root system', ['One cotyledon and fibrous roots', 'No cotyledons', 'Parallel venation'], 'Beans, mango and orange are examples.', T.sperm);
add('Double fertilisation is a feature of:', 'Angiosperms', ['Gymnosperms', 'Ferns', 'Mosses'], 'One sperm fuses with the egg to form a zygote and the other with the polar nuclei to form triploid endosperm.', T.sperm);

// ---------------- plant tissues
add('Cells that divide to produce new cells at the tips of roots and shoots are found in the:', 'Apical meristem', ['Epidermis', 'Cortex', 'Xylem'], 'Apical meristems are responsible for primary growth in length.', T.ptis);
add('Water and dissolved minerals are conducted upwards in the plant by:', 'Xylem', ['Phloem', 'Cambium', 'Epidermis'], 'Xylem vessels and tracheids are dead, lignified cells.', T.ptis);
add('Sugars made in the leaves are transported by:', 'Phloem', ['Xylem', 'Collenchyma', 'Cork'], 'Phloem sieve tubes are supported by companion cells.', T.ptis);
add('Secondary growth that increases the girth of a stem is brought about by the:', 'Vascular cambium', ['Apical meristem', 'Pith', 'Guard cells'], 'The cambium forms secondary xylem inwards and secondary phloem outwards.', T.ptis);
add('Which plant tissue gives flexible support to young stems and leaf petioles, and has unevenly thickened walls?', 'Collenchyma', ['Sclerenchyma', 'Parenchyma', 'Xylem vessels'], 'Sclerenchyma has thick lignified walls and gives rigid support.', T.ptis);
add('Guard cells are found in the:', 'Epidermis, where they control the opening of stomata', ['Xylem', 'Pith', 'Root cap'], 'Guard cells regulate gas exchange and water loss.', T.ptis);
add('Parenchyma cells are mainly concerned with:', 'Photosynthesis, storage and wound repair', ['Rigid support', 'Transport of water over long distances', 'Producing new cells at the root tip'], 'They are thin-walled, living, and make up the bulk of soft plant tissues.', T.ptis);

// ---------------- animal taxonomy and tissues
add('Sponges belong to the phylum:', 'Porifera', ['Cnidaria', 'Annelida', 'Mollusca'], 'Sponges have pores and collar cells, and no true tissues.', T.ani);
add('Jellyfish, sea anemones and corals are classified as:', 'Cnidaria', ['Porifera', 'Echinodermata', 'Platyhelminthes'], 'Cnidarians have stinging cells called cnidocytes and radial symmetry.', T.ani);
add('The tapeworm and the liver fluke are members of the phylum:', 'Platyhelminthes', ['Nematoda', 'Annelida', 'Arthropoda'], 'Flatworms are flat and unsegmented, and have no body cavity.', T.ani);
add('Earthworms are segmented worms of the phylum:', 'Annelida', ['Nematoda', 'Platyhelminthes', 'Mollusca'], 'Annelids have a true coelom and a closed circulatory system.', T.ani);
add('Insects, spiders and crabs share the presence of:', 'A chitinous exoskeleton and jointed appendages', ['A backbone', 'A shell of calcium carbonate', 'Radial symmetry'], 'These are features of phylum Arthropoda.', T.ani);
add('Which class of arthropods has three pairs of legs and usually two pairs of wings?', 'Insecta', ['Arachnida', 'Crustacea', 'Myriapoda'], 'Insects have a body divided into head, thorax and abdomen.', T.ani);
add('Snails, clams and octopuses belong to:', 'Mollusca', ['Echinodermata', 'Annelida', 'Cnidaria'], 'Molluscs have a muscular foot, a mantle and often a shell.', T.ani);
add('Starfish and sea urchins are in the phylum:', 'Echinodermata', ['Mollusca', 'Cnidaria', 'Arthropoda'], 'Adults show radial symmetry and have a water vascular system.', T.ani);
add('The binomial name of modern humans is Homo sapiens. In this name, Homo is the:', 'Genus', ['Species', 'Family', 'Order'], 'The first word is the genus, written with a capital letter, and the second is the species epithet.', T.ani);
add('The correct order of taxonomic ranks from the largest group to the smallest is:', 'Domain, kingdom, phylum, class, order, family, genus, species', ['Kingdom, domain, class, phylum, family, order, species, genus', 'Species, genus, family, order, class, phylum, kingdom', 'Domain, phylum, kingdom, order, class, genus, family, species'], 'Each rank is contained in the one above it.', T.ani);
add('Which of the following is a characteristic of all chordates at some stage of life?', 'A notochord and a dorsal hollow nerve cord', ['A chitinous exoskeleton', 'A ventral solid nerve cord', 'A water vascular system'], 'Vertebrates replace the notochord with the vertebral column in the adult.', T.ani);
add('Epithelial tissue:', 'Covers body surfaces and lines cavities and organs', ['Carries messages as electrical impulses', 'Contracts to produce movement', 'Stores fat'], 'Epithelia sit on a basement membrane and have little extracellular matrix.', T.atis);
add('Skin and the lining of the mouth, which must withstand abrasion, are made of:', 'Stratified squamous epithelium', ['Simple cuboidal epithelium', 'Simple columnar epithelium', 'Cartilage'], 'Layers of flat cells protect against wear.', T.atis);
add('Bone, cartilage and blood are all types of:', 'Connective tissue', ['Epithelial tissue', 'Muscle tissue', 'Nervous tissue'], 'Connective tissues have cells scattered in an extracellular matrix.', T.atis);
add('Which muscle tissue is striated, branched and found only in the heart?', 'Cardiac muscle', ['Skeletal muscle', 'Smooth muscle', 'Cartilage'], 'Intercalated discs link cardiac cells and allow coordinated contraction.', T.atis);
add('Smooth muscle is found in:', 'The walls of the intestine and blood vessels', ['The biceps', 'The tongue only', 'Tendons'], 'It is involuntary and non-striated.', T.atis);
add('The cells that carry electrical impulses are the:', 'Neurons', ['Fibroblasts', 'Osteocytes', 'Erythrocytes'], 'A neuron has dendrites, a cell body and an axon.', T.atis);
add('Tendons connect:', 'Muscle to bone', ['Bone to bone', 'Muscle to muscle', 'Skin to muscle'], 'Ligaments connect bone to bone.', T.atis);

module.exports = out;
