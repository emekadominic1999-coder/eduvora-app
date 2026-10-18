// BIO 102 batch 3 - hand-set from OpenStax Biology 2e and Concepts of Biology. Musculoskeletal, senses, immunity, plant physiology, biomes, conservation, genetics problems.
const L = require('../sta/lib');
const { add, out } = L;
const T = {
  gen: 'Mendelian Genetics', pop: 'Population Genetics', xl: 'X-linked Inheritance', dna: 'DNA, Transcription and Translation', mut: 'Mutations', mei: 'Meiosis', cyc: 'Cell Cycle',
  pho: 'Photosynthesis', res: 'Cellular Respiration Overview', evo: 'Evolution and Natural Selection', eco: 'Ecosystems and Energy Flow', cyc2: 'Nutrient Cycles', pop2: 'Population Ecology', bio: 'Biomes and Conservation',
  dig: 'Digestive System', circ: 'Circulatory System', resp: 'Respiratory System', exc: 'Excretion and the Kidney', hor: 'Hormones and Homeostasis', nerv: 'Nervous System', mus: 'Muscular and Skeletal Systems', sens: 'Sense Organs', imm: 'Immune System', rep: 'Reproduction and Development', plant: 'Plant Physiology', bt: 'Biotechnology',
};
const chk = (a, b) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed ' + a + ' vs ' + b); };

// ---------------- genetics problems
add('A tall plant (Tt) is self-fertilised and produces 160 offspring. The number of dwarf offspring expected is:', '40', ['120', '80', '160'], 'One quarter of the offspring are tt: 160 × 1/4 = 40.', T.gen);
chk(160 / 4, 40);
add('In pea plants, yellow seed (Y) is dominant to green (y). A cross between YY and yy gives an F1 generation that is:', 'All yellow and heterozygous', ['Half yellow and half green', 'All green', 'All yellow and homozygous'], 'Every F1 plant receives Y from one parent and y from the other.', T.gen);
add('Two yellow-seeded plants produce some green-seeded offspring. The parents must have been:', 'Both heterozygous (Yy)', ['Both YY', 'YY and Yy', 'Both yy'], 'Green offspring are yy, so each parent must carry a y allele, and both look yellow, so both are Yy.', T.gen);
add('Brown eyes (B) are dominant to blue eyes (b). A brown-eyed man whose mother had blue eyes marries a blue-eyed woman. The probability that their child has blue eyes is:', '1/2', ['1/4', '0', '3/4'], 'The man is Bb because his mother was bb. A Bb × bb cross gives half Bb and half bb.', T.gen);
add('A cross between a pure-breeding red-flowered plant (RR) and a pure-breeding white-flowered plant (rr) that shows incomplete dominance gives an F2 ratio of:', '1 red : 2 pink : 1 white', ['3 red : 1 white', '1 red : 1 white', '9 : 3 : 3 : 1'], 'F1 plants are all pink (Rr). F1 × F1 gives 1 RR : 2 Rr : 1 rr, and each genotype has a different phenotype.', T.gen);
add('Round (R) and yellow (Y) seeds are dominant. A test cross of RrYy with rryy is expected to give round yellow, round green, wrinkled yellow and wrinkled green in the ratio:', '1 : 1 : 1 : 1', ['9 : 3 : 3 : 1', '3 : 1', '1 : 2 : 1'], 'The double heterozygote makes four equally likely gametes and the double recessive makes only ry.', T.gen);
add('How many different gametes can an individual with the genotype AaBbCc produce, assuming independent assortment?', '8', ['3', '6', '9'], 'The number of gametes is 2^n, where n is the number of heterozygous genes: 2³ = 8.', T.gen);
chk(Math.pow(2, 3), 8);
add('A woman is homozygous for blood group A and her husband is homozygous for blood group B. Their children will be:', 'All blood group AB', ['All blood group A', 'Half A and half B', 'All blood group O'], 'The children are IAIB.', T.gen);
add('Rhesus (Rh) negative blood is recessive. A child who is Rh-negative has two Rh-positive parents. The parents\' genotypes are:', 'Both Dd', ['Both DD', 'DD and Dd', 'dd and Dd'], 'The child is dd, so each parent carries d, and both are Rh-positive, so each is Dd.', T.gen);
add('Albinism is an autosomal recessive condition. Two normal parents have an albino child. The probability that their next child is also albino is:', '1/4', ['1/2', '3/4', '0'], 'Both parents must be carriers (Aa), and Aa × Aa gives one quarter aa.', T.gen);
add('A genotype can be found from the phenotype of an organism showing a recessive trait because:', 'It must be homozygous recessive', ['It must be heterozygous', 'It can be either homozygous or heterozygous', 'Recessive genes are always on the X chromosome'], 'A recessive trait is expressed only when two copies of the recessive allele are present.', T.gen);
add('Huntington\'s disease is caused by a dominant allele. A person with one affected parent (heterozygous) has what chance of inheriting the allele?', '50%', ['25%', '75%', '100%'], 'The affected parent passes on either the normal or the dominant allele with equal chance.', T.gen);
add('A man with haemophilia (XhY) and a normal woman who is not a carrier (XHXH) have children. All their daughters will be:', 'Carriers', ['Haemophiliacs', 'Normal and not carriers', 'Half haemophiliac'], 'Daughters receive Xh from the father and XH from the mother.', T.xl);
add('Which statement about X-linked recessive disorders is correct?', 'An affected man cannot pass the disorder directly to his sons', ['An affected man passes the allele to all his sons', 'Women are affected more often than men', 'The allele is carried on the Y chromosome'], 'Sons receive the Y chromosome from their father, not his X.', T.xl);
add('A mother is a carrier for colour blindness (XCXc) and the father has normal vision (XCY). The probability that a daughter is colour-blind is:', '0', ['1/2', '1/4', '1'], 'Daughters receive XC from the father so they cannot be colour-blind, though half will be carriers.', T.xl);
add('Chromosomes that are the same size and carry the same genes in the same order are called:', 'Homologous chromosomes', ['Sister chromatids', 'Sex chromosomes', 'Autosomes only'], 'One of each pair is inherited from each parent.', T.mei);
add('Non-disjunction is the failure of:', 'Chromosomes to separate properly during meiosis', ['DNA to replicate', 'The spindle to form in mitosis', 'Cytokinesis to start'], 'It results in gametes with an extra or a missing chromosome.', T.mut);
add('A change in the base sequence of DNA that does not change the amino acid sequence of the protein is a:', 'Silent mutation', ['Missense mutation', 'Nonsense mutation', 'Frameshift mutation'], 'It happens because the genetic code is redundant.', T.mut);
add('A mutation that changes a codon into a stop codon is a:', 'Nonsense mutation', ['Missense mutation', 'Silent mutation', 'Inversion'], 'It produces a shortened protein.', T.mut);
add('Mutations that occur in body cells (somatic cells):', 'Are not passed to the offspring', ['Are always passed to the offspring', 'Occur only in gametes', 'Are always harmful to offspring'], 'Only mutations in gametes can be inherited.', T.mut);
add('Genes whose products are needed in all cells, such as those for enzymes of glycolysis, are expressed in:', 'All cells all the time', ['Only one tissue', 'Only embryos', 'Only during mitosis'], 'They are called housekeeping genes.', T.dna);
add('The lac operon of Escherichia coli is switched on when:', 'Lactose is present and glucose is absent', ['Glucose is present and lactose is absent', 'Both glucose and lactose are absent', 'Only oxygen is present'], 'Lactose binds to the repressor, which then leaves the operator.', T.dna);

// ---------------- muscular and skeletal system
add('The human skeleton has how many bones in an adult?', '206', ['106', '306', '156'], 'A newborn has more, because many bones fuse as the child grows.', T.mus);
add('Which bones make up the axial skeleton?', 'Skull, vertebral column and rib cage', ['Limbs and girdles', 'Pelvis and arms', 'Hands and feet only'], 'The appendicular skeleton includes the limbs and the limb girdles.', T.mus);
add('The shoulder joint and the hip joint are examples of:', 'Ball and socket joints', ['Hinge joints', 'Pivot joints', 'Gliding joints'], 'They allow movement in many directions.', T.mus);
add('The elbow and the knee are:', 'Hinge joints', ['Ball and socket joints', 'Pivot joints', 'Immovable joints'], 'They allow movement in one plane only.', T.mus);
add('The joints between the bones of the skull are:', 'Immovable (fixed) joints', ['Hinge joints', 'Ball and socket joints', 'Gliding joints'], 'They are called sutures.', T.mus);
add('Cartilage at the ends of bones in a joint:', 'Reduces friction and acts as a shock absorber', ['Joins muscle to bone', 'Makes red blood cells', 'Stores calcium'], 'Synovial fluid also lubricates the joint.', T.mus);
add('Red blood cells are produced in the:', 'Red bone marrow', ['Yellow bone marrow', 'Liver of adults', 'Cartilage'], 'Yellow marrow stores fat.', T.mus);
add('Muscle contraction results from the sliding of:', 'Actin and myosin filaments past each other', ['Collagen and elastin fibres', 'Keratin filaments', 'Microtubules only'], 'This is the sliding filament model.', T.mus);
add('The energy used for muscle contraction is supplied directly by:', 'ATP', ['Glucose', 'Oxygen', 'Starch'], 'ATP is needed for the myosin heads to detach and re-attach.', T.mus);
add('Which ion triggers the contraction of a muscle fibre?', 'Calcium', ['Sodium only', 'Iron', 'Chloride'], 'Calcium released from the sarcoplasmic reticulum exposes the binding sites on actin.', T.mus);
add('Muscles that work in opposite ways, such as the biceps and the triceps, are called:', 'Antagonistic muscles', ['Synergistic muscles', 'Cardiac muscles', 'Smooth muscles'], 'When the biceps contracts the triceps relaxes.', T.mus);
add('The triceps muscle straightens the arm when it:', 'Contracts while the biceps relaxes', ['Relaxes while the biceps contracts', 'Contracts together with the biceps', 'Contracts and lengthens'], 'Muscles can only pull, so they work in pairs.', T.mus);
add('The build-up of lactic acid in muscles during strenuous exercise is caused by:', 'Anaerobic respiration due to oxygen debt', ['Too much oxygen', 'Photosynthesis', 'Fat storage'], 'After exercise, extra oxygen is needed to remove the lactic acid.', T.mus);
add('Vitamin D is needed for strong bones because it:', 'Helps the absorption of calcium', ['Provides energy', 'Is a component of collagen', 'Makes red blood cells'], 'Lack of vitamin D causes rickets in children.', T.mus);

// ---------------- sense organs
add('The part of the eye that contains the light-sensitive cells is the:', 'Retina', ['Cornea', 'Iris', 'Lens'], 'Rods and cones are in the retina.', T.sens);
add('Which cells in the retina detect colour and work best in bright light?', 'Cones', ['Rods', 'Neurons only', 'Glial cells'], 'Rods work in dim light.', T.sens);
add('The structure of the eye that controls the amount of light entering is the:', 'Iris', ['Cornea', 'Lens', 'Sclera'], 'The iris changes the diameter of the pupil.', T.sens);
add('In bright light the pupil:', 'Becomes smaller', ['Becomes larger', 'Stays the same', 'Closes completely'], 'The circular muscles of the iris contract.', T.sens);
add('To focus on a near object, the lens becomes:', 'Thicker and more rounded', ['Thinner and flatter', 'Opaque', 'Smaller in diameter only'], 'The ciliary muscles contract and the suspensory ligaments slacken.', T.sens);
add('A person who can see near objects clearly but not distant ones is:', 'Short-sighted (myopic)', ['Long-sighted', 'Colour-blind', 'Astigmatic'], 'The image of a distant object forms in front of the retina, and a concave lens corrects it.', T.sens);
add('The blind spot of the eye is the place where:', 'The optic nerve leaves the retina and there are no receptors', ['The lens is attached', 'Light is focused best', 'The cones are most dense'], 'This region cannot detect light.', T.sens);
add('Vitamin A deficiency can cause:', 'Night blindness', ['Rickets', 'Scurvy', 'Goitre'], 'It is needed for the pigment rhodopsin in the rods.', T.sens);
add('Sound vibrations in the ear are changed into nerve impulses in the:', 'Cochlea', ['Eardrum', 'Semicircular canals', 'Eustachian tube'], 'Hair cells in the organ of Corti detect the vibrations.', T.sens);
add('The semicircular canals of the ear are concerned with:', 'Balance', ['Hearing', 'Taste', 'Smell'], 'They detect rotation of the head.', T.sens);
add('The three small bones of the middle ear are the:', 'Malleus, incus and stapes', ['Femur, tibia and fibula', 'Radius, ulna and humerus', 'Atlas, axis and sacrum'], 'They carry and amplify vibrations from the eardrum to the oval window.', T.sens);
add('The Eustachian tube connects the middle ear to the:', 'Throat (pharynx)', ['Brain', 'Cochlea', 'Outer ear canal'], 'It equalises air pressure on both sides of the eardrum.', T.sens);
add('Receptors for touch, pressure and temperature are found mainly in the:', 'Dermis of the skin', ['Epidermis only', 'Hair shaft', 'Sweat gland ducts'], 'The dermis has nerve endings and blood vessels.', T.sens);

// ---------------- skin, temperature, immunity
add('When the body is too hot, the skin responds by:', 'Dilation of blood vessels and sweating', ['Constriction of blood vessels and shivering', 'Closing the sweat pores', 'Erecting the hairs and producing less sweat'], 'Heat is lost by radiation and by evaporation of sweat.', T.hor);
add('Shivering when we are cold helps to:', 'Produce heat by muscle contraction', ['Increase sweating', 'Dilate skin capillaries', 'Reduce metabolic rate'], 'It is a negative feedback response to low body temperature.', T.hor);
add('The first line of defence of the body against pathogens includes:', 'Skin and mucous membranes', ['Antibodies', 'Memory cells', 'Vaccines'], 'These are non-specific barriers.', T.imm);
add('Neutrophils and macrophages protect the body by:', 'Engulfing and destroying pathogens (phagocytosis)', ['Making antibodies', 'Carrying oxygen', 'Clotting blood'], 'They are part of the innate immune response.', T.imm);
add('An antigen is:', 'A foreign substance that triggers an immune response', ['A protein made by B cells', 'A type of white blood cell', 'A hormone'], 'Antigens are usually proteins or polysaccharides on the surface of pathogens.', T.imm);
add('Passive immunity is obtained when:', 'Ready-made antibodies are received, such as from the mother\'s milk', ['The body makes its own antibodies after vaccination', 'A person recovers from a disease', 'A person is infected by a pathogen'], 'It gives immediate but short-lived protection.', T.imm);
add('A child who is given the BCG vaccine develops:', 'Active artificial immunity', ['Passive natural immunity', 'Passive artificial immunity', 'Active natural immunity'], 'The child\'s own cells make antibodies and memory cells after the vaccine.', T.imm);
add('An allergy is caused by:', 'An over-reaction of the immune system to a harmless substance', ['A virus', 'Lack of white blood cells', 'A bacterial toxin'], 'Histamine is released in allergic reactions.', T.imm);

// ---------------- plant physiology
add('Water enters root hair cells by:', 'Osmosis', ['Active transport', 'Phagocytosis', 'Transpiration'], 'The soil water has a higher water potential than the cell sap.', T.plant);
add('Mineral ions such as nitrate are absorbed into the roots mainly by:', 'Active transport', ['Osmosis', 'Simple diffusion only', 'Exocytosis'], 'Plants use ATP to take up ions against a concentration gradient.', T.plant);
add('The main force that pulls water up through the xylem of a tall tree is:', 'Transpiration pull, helped by cohesion of water molecules', ['Root pressure alone', 'Gravity', 'Active transport in the xylem'], 'The loss of water at the leaves creates tension in the water column.', T.plant);
add('Guttation is the:', 'Loss of liquid water from the tips of leaves, caused by root pressure', ['Loss of water vapour through stomata', 'Movement of sugars in the phloem', 'Absorption of water by seeds'], 'It occurs at night when the air is humid.', T.plant);
add('The potometer is used to measure:', 'The rate of water uptake by a shoot', ['The rate of respiration', 'The rate of growth of a root', 'The pH of the soil'], 'It is used as an estimate of the rate of transpiration.', T.plant);
add('A plant placed in a dark cupboard for several days becomes pale and tall with small leaves. This is called:', 'Etiolation', ['Phototropism', 'Dormancy', 'Vernalisation'], 'Without light, plants use their stored food to grow tall quickly in search of light.', T.plant);
add('The growth of a root towards water is an example of:', 'Hydrotropism', ['Phototropism', 'Geotropism', 'Thigmotropism'], 'Tropisms are growth responses towards or away from a stimulus.', T.plant);
add('Shoots grow upwards and roots grow downwards. This response to gravity is:', 'Geotropism (gravitropism)', ['Phototropism', 'Hydrotropism', 'Chemotropism'], 'Shoots are negatively geotropic and roots are positively geotropic.', T.plant);
add('The coiling of tendrils around a support is an example of:', 'Thigmotropism', ['Phototropism', 'Geotropism', 'Hydrotropism'], 'It is a response to touch.', T.plant);
add('Cytokinins in plants mainly:', 'Promote cell division and delay leaf ageing', ['Promote fruit ripening', 'Close the stomata', 'Cause seed dormancy'], 'They work with auxin in tissue culture.', T.plant);
add('The loss of leaves by deciduous trees in the dry season helps to:', 'Reduce water loss', ['Increase photosynthesis', 'Increase transpiration', 'Absorb more minerals'], 'Water loss through the leaves is greatly reduced.', T.plant);
add('Which of the following is a nutrient that plants take up and that is NOT needed in large amounts?', 'Zinc', ['Nitrogen', 'Phosphorus', 'Potassium'], 'Zinc is a micronutrient.', T.plant);
add('Leaves of nitrogen-deficient plants are:', 'Pale green or yellow, especially the older ones', ['Dark green and curled', 'Purple only on the margin', 'Brown and with black spots on young leaves'], 'Nitrogen is needed for chlorophyll and is moved from old leaves to new growth.', T.plant);
add('Carnivorous plants such as the pitcher plant trap insects to obtain:', 'Nitrogen compounds that are scarce in the soil', ['Water', 'Sugar', 'Carbon dioxide'], 'They grow in nitrogen-poor soils.', T.plant);
add('Light-dependent opening of stomata is mainly due to:', 'Uptake of potassium ions and water by the guard cells', ['Loss of water from the guard cells', 'A fall in carbon dioxide only', 'Production of starch'], 'Water follows the potassium ions into the guard cells by osmosis.', T.plant);

// ---------------- reproduction and development
add('The hormone that stimulates development of follicles in the ovary is:', 'FSH (follicle stimulating hormone)', ['LH', 'Progesterone', 'Prolactin'], 'Developing follicles secrete oestrogen.', T.rep);
add('In the menstrual cycle, menstruation occurs when:', 'Levels of oestrogen and progesterone fall and the uterine lining breaks down', ['Levels of progesterone rise', 'An egg is fertilised', 'LH reaches a peak'], 'If implantation occurs, the corpus luteum continues to make progesterone.', T.rep);
add('Implantation is the attachment of the:', 'Embryo (blastocyst) to the lining of the uterus', ['Egg to the sperm', 'Sperm to the egg membrane', 'Placenta to the foetus'], 'It occurs about six to ten days after fertilisation.', T.rep);
add('Which hormone is detected in a pregnancy test?', 'Human chorionic gonadotropin (hCG)', ['Insulin', 'FSH', 'Testosterone'], 'It is secreted by the cells around the early embryo.', T.rep);
add('The amnion contains fluid that:', 'Protects the foetus against shock', ['Supplies food', 'Produces hormones', 'Carries sperm'], 'It also allows the foetus to move.', T.rep);
add('The umbilical cord connects the:', 'Foetus to the placenta', ['Placenta to the uterus wall', 'Ovary to the uterus', 'Vagina to the cervix'], 'It carries two arteries and one vein.', T.rep);
add('Milk production is stimulated by the hormone:', 'Prolactin', ['Oxytocin', 'Progesterone', 'Testosterone'], 'Oxytocin causes milk ejection and contractions of the uterus.', T.rep);
add('The secondary sexual characteristics in males are controlled by:', 'Testosterone', ['Oestrogen', 'Progesterone', 'Thyroxine'], 'It is secreted by the Leydig cells of the testes.', T.rep);
add('Reproduction in which a new individual arises from one parent, without gametes, is:', 'Asexual reproduction', ['Sexual reproduction', 'Fertilisation', 'Meiosis'], 'The offspring are genetically identical to the parent.', T.rep);
add('A potato tuber, a sweet potato and a ginger rhizome are used by farmers for:', 'Vegetative propagation', ['Sexual reproduction', 'Pollination', 'Seed dispersal'], 'New plants arise from buds on the stem or root, and are clones of the parent.', T.rep);
add('Budding is a method of asexual reproduction seen in:', 'Yeast and Hydra', ['Earthworm and frog', 'Human and goat', 'Maize and rice'], 'A bud grows from the parent and separates.', T.rep);
add('Metamorphosis in a frog involves a change from:', 'Tadpole with gills to an adult with lungs', ['Adult to egg', 'Egg to adult directly', 'Land to water only'], 'Thyroxine controls metamorphosis.', T.rep);

// ---------------- ecology: biomes and conservation
add('The tropical rainforest is characterised by:', 'High rainfall, high temperature and high species diversity', ['Low rainfall and few species', 'Permanently frozen ground', 'Very low temperature and short grasses'], 'It has several layers of vegetation, from the forest floor to the canopy.', T.bio);
add('The savanna biome is typically:', 'Grassland with scattered trees and a clear dry season', ['Dense forest without a dry season', 'Permanently frozen', 'A treeless desert'], 'The Guinea savanna covers much of central Nigeria.', T.bio);
add('The tundra is a cold region in which:', 'The ground below the surface is permanently frozen (permafrost)', ['There is dense rainforest', 'Rainfall is very high all year', 'Temperatures are high'], 'Plants are small, such as mosses and lichens.', T.bio);
add('Desert plants are adapted to the dry environment by:', 'Having thick cuticles, reduced leaves and deep or widespread roots', ['Having large thin leaves', 'Having many stomata open all day', 'Having shallow roots only'], 'These features reduce water loss and increase absorption.', T.bio);
add('Organisms living in the open water of a lake that float and drift are called:', 'Plankton', ['Benthos', 'Nekton', 'Epiphytes'], 'Phytoplankton make food and zooplankton feed on them.', T.bio);
add('The place where an organism lives is its:', 'Habitat', ['Niche', 'Community', 'Population'], 'The niche is the role of the organism in the ecosystem.', T.eco);
add('An organism\'s niche is best described as:', 'Its role in the ecosystem, including what it eats and how it interacts with other species', ['The place where it lives', 'Its body size', 'Its scientific name'], 'Two species with the same niche in a habitat will compete.', T.eco);
add('Biotic factors in an ecosystem include:', 'Predators, parasites and competitors', ['Temperature, rainfall and soil pH', 'Light and wind', 'Only plants'], 'Abiotic factors are the non-living factors.', T.eco);
add('Which of the following is an abiotic factor?', 'Soil pH', ['A predator', 'A parasite', 'A pollinator'], 'Temperature, light, water and wind are also abiotic factors.', T.eco);
add('The main cause of the loss of biodiversity in the world today is:', 'Habitat destruction by human activities', ['Volcanic eruptions', 'Lack of sunlight', 'Moon cycles'], 'Overexploitation, pollution and invasive species also contribute.', T.bio);
add('Conservation of species in their natural habitat, as in a national park, is called:', 'In situ conservation', ['Ex situ conservation', 'Captive breeding', 'Cloning'], 'Zoos and seed banks are examples of ex situ conservation.', T.bio);
add('Deforestation can lead to:', 'Soil erosion and loss of habitat', ['Increase in rainfall in the area', 'Decrease in carbon dioxide', 'Fewer floods'], 'Without roots to hold the soil, topsoil is washed away.', T.bio);
add('The ozone layer protects living things from:', 'Harmful ultraviolet radiation', ['Visible light', 'Infrared radiation', 'Cosmic dust'], 'Chlorofluorocarbons (CFCs) damage the ozone layer.', T.bio);
add('Acid rain is caused mainly by:', 'Sulphur dioxide and nitrogen oxides released into the air', ['Carbon monoxide', 'Oxygen', 'Hydrogen'], 'These gases dissolve in rain water to form sulphuric and nitric acids.', T.bio);
add('A biological method of controlling a crop pest is:', 'Introducing a natural predator of the pest', ['Spraying with insecticide', 'Burning the farm', 'Increasing the use of fertiliser'], 'It avoids the use of chemicals.', T.bio);
add('An example of an invasive species problem in Nigerian waters is the spread of:', 'Water hyacinth', ['Mangrove', 'Cassava', 'Palm tree'], 'It covers the water surface and blocks light and oxygen.', T.bio);
add('A sample of 50 trees in a forest of 2000 trees is taken, and 5 are of a particular species. The estimated number of that species in the forest is:', '200', ['100', '400', '20'], '5/50 = 10% of the sample. 10% of 2000 = 200.', T.pop2);
chk(5 / 50 * 2000, 200);
add('In a mark-release-recapture study, 40 fish are marked and released. A later sample of 50 fish contains 10 marked fish. The estimated population is:', '200', ['400', '100', '500'], 'Population = (marked × total in second sample) ÷ marked recaptured = 40 × 50 ÷ 10 = 200.', T.pop2);
chk(40 * 50 / 10, 200);
add('A quadrat of 1 m² is placed 20 times and a total of 60 plants are counted. The mean density is:', '3 plants per m²', ['0.33 plants per m²', '6 plants per m²', '30 plants per m²'], '60 ÷ 20 = 3 plants per square metre.', T.pop2);
chk(60 / 20, 3);
add('A graph of population growth that has an S-shape (sigmoid curve) shows that the population:', 'Grows slowly, then fast, and then levels off at the carrying capacity', ['Grows at the same rate without limit', 'Declines to zero', 'Stays constant at all times'], 'The environment resists growth as resources become limiting.', T.pop2);
add('Predator-prey populations often show:', 'Cycles in which predator numbers follow the changes in prey numbers', ['No relationship', 'Constant numbers', 'Exponential growth of both'], 'More prey allows predators to increase, and more predators then reduce the prey.', T.pop2);

// ---------------- evolution and biotechnology extras
add('The theory of natural selection was proposed independently by Charles Darwin and:', 'Alfred Russel Wallace', ['Gregor Mendel', 'Louis Pasteur', 'Robert Hooke'], 'They both published their ideas in 1858.', T.evo);
add('Industrial melanism in the peppered moth shows that:', 'Dark moths survived better where soot darkened tree trunks', ['Moths changed colour to match trees on purpose', 'Light moths were stronger', 'Birds prefer dark moths'], 'Predators removed the more visible moths, so the alleles for dark colour became common.', T.evo);
add('Which of the following is evidence for evolution from comparative embryology?', 'Vertebrate embryos look similar in early stages', ['Fossils found in sedimentary rock', 'Dogs can be bred into many varieties', 'Mutation rates in bacteria'], 'Similar early development suggests common ancestry.', T.evo);
add('The process in which populations of one species become reproductively isolated and form new species is:', 'Speciation', ['Extinction', 'Hybridisation', 'Mutation'], 'Geographical isolation is the most common first step (allopatric speciation).', T.evo);
add('Convergent evolution is when:', 'Unrelated organisms evolve similar features because of similar environments', ['Closely related species become different', 'Species become extinct', 'Organisms mate with other species'], 'The streamlined body of sharks and dolphins is an example.', T.evo);
add('A DNA fingerprint is used in forensic science to:', 'Identify individuals from the pattern of repeated DNA sequences', ['Determine blood group only', 'Measure the mass of DNA', 'Make proteins'], 'Each person except identical twins has a unique pattern.', T.bt);
add('Genetically modified crops such as insect-resistant cotton have been made by:', 'Inserting a gene from another organism into the plant', ['Selective breeding only', 'Using fertilisers', 'Irradiation of the soil'], 'The Bt gene comes from the bacterium Bacillus thuringiensis.', T.bt);
add('Tissue culture is used to:', 'Grow many identical plants from a small piece of tissue', ['Produce seeds from pollen', 'Cross two species', 'Change the number of chromosomes'], 'The plants produced are clones.', T.bt);
add('Selective breeding for high milk yield in cattle is an example of:', 'Artificial selection', ['Natural selection', 'Genetic drift', 'Gene therapy'], 'People choose which animals reproduce.', T.bt);
add('Gene therapy aims to:', 'Treat an inherited disease by replacing or correcting a faulty gene', ['Make people taller', 'Clone an adult', 'Remove all genes'], 'A normal gene is delivered into the patient\'s cells, often with a modified virus.', T.bt);

module.exports = out;
