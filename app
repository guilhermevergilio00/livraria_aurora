from flask import Flask, render_template, request, redirect, url_for, flash
import csv
import os

app = Flask(__name__)
app.secret_key = "dev-secret-key"  # for flash messages

# --- Dados da empresa ---
EMPRESA = {
    "nome": "Livraria Aurora",
    "slogan": "Histórias que iluminam suas ideias.",
    "sobre": (
        "Somos uma livraria online brasileira apaixonada por boas histórias. "
        "Selecionamos títulos de qualidade em diferentes gêneros, com foco em curadoria, preço justo e entrega rápida."
    ),
    "missao": "Conectar pessoas a livros transformadores.",
    "visao": "Ser referência nacional em curadoria literária online.",
    "valores": ["Ética", "Acessibilidade", "Curadoria", "Diversidade", "Sustentabilidade"],
}

# --- Catálogo ---
PRODUTOS = {
    "Ficção": [
        {"id": "fic-1", "titulo": "O Jardim das Estrelas", "autor": "L. Carvalho", "preco": 49.9, "descricao": "Um romance sobre recomeços e constelações.", "img": "ficcao1.svg"},
        {"id": "fic-2", "titulo": "Ruas de Abril", "autor": "M. Duarte", "preco": 39.9, "descricao": "Amizade, música e poesia nas esquinas da cidade.", "img": "ficcao2.svg"},
        {"id": "fic-3", "titulo": "Cartas para o Amanhã", "autor": "T. Nogueira", "preco": 44.5, "descricao": "Um encontro improvável muda a história de duas famílias.", "img": "ficcao3.svg"},
        {"id": "fic-4", "titulo": "Metade do Sol", "autor": "A. R. Lima", "preco": 42.0, "descricao": "Um retrato delicado de pertencimento e identidade.", "img": "ficcao4.svg"},
    ],
    "Policial": [
        {"id": "pol-1", "titulo": "A Última Pista", "autor": "C. Ferreira", "preco": 54.9, "descricao": "Uma detetive enfrenta um caso frio que volta a queimar.", "img": "policial1.svg"},
        {"id": "pol-2", "titulo": "Noite Sem Rosto", "autor": "R. Martins", "preco": 47.0, "descricao": "Crimes em série e segredos na alta sociedade.", "img": "policial2.svg"},
        {"id": "pol-3", "titulo": "O Caso do Relógio", "autor": "H. Prado", "preco": 45.5, "descricao": "Um enigma de quarto fechado com tempo contra o detetive.", "img": "policial3.svg"},
        {"id": "pol-4", "titulo": "Véu de Cinzas", "autor": "D. Guimarães", "preco": 52.0, "descricao": "Corrupção, poder e um desaparecimento impossível.", "img": "policial4.svg"},
    ],
    "Suspense": [
        {"id": "sus-1", "titulo": "A Casa ao Lado", "autor": "E. A. Braga", "preco": 46.9, "descricao": "O novo vizinho não é bem quem parece ser.", "img": "suspense1.svg"},
        {"id": "sus-2", "titulo": "Neblina", "autor": "B. Teixeira", "preco": 43.9, "descricao": "Pequena cidade, grandes silêncios.", "img": "suspense2.svg"},
        {"id": "sus-3", "titulo": "Linha de Gelo", "autor": "S. Mota", "preco": 51.0, "descricao": "Uma pesquisadora isola a verdade nas montanhas geladas.", "img": "suspense3.svg"},
        {"id": "sus-4", "titulo": "O Sussurro", "autor": "J. Amaral", "preco": 48.0, "descricao": "Vozes antigas ecoam por corredores modernos.", "img": "suspense4.svg"},
    ],
}

FAQ = [
    {"q": "Como funciona o envio?", "a": "Enviamos para todo o Brasil via correios e transportadoras parceiras."},
    {"q": "Quais são as formas de pagamento?", "a": "Cartão de crédito, Pix e boleto bancário."},
    {"q": "Posso trocar um produto?", "a": "Sim. Trocas em até 7 dias corridos após o recebimento, conforme o CDC."},
    {"q": "Vocês atendem pessoas jurídicas?", "a": "Sim. Temos condições especiais para compras corporativas. Entre em contato."},
]

def salvar_mensagem(nome, email, assunto, mensagem):
    caminho = os.path.join(os.path.dirname(__file__), "mensagens.csv")
    arquivo_existe = os.path.exists(caminho)
    with open(caminho, "a", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        if not arquivo_existe:
            writer.writerow(["nome", "email", "assunto", "mensagem"])
        writer.writerow([nome, email, assunto, mensagem])

@app.route("/")
def index():
    return render_template("index.html", empresa=EMPRESA)

@app.route("/produtos/")
def produtos():
    return render_template("produtos.html", produtos=PRODUTOS)

@app.route("/contato/", methods=["GET", "POST"])
def contato():
    if request.method == "POST":
        nome = request.form.get("nome", "").strip()
        email = request.form.get("email", "").strip()
        assunto = request.form.get("assunto", "").strip()
        mensagem = request.form.get("mensagem", "").strip()

        if not nome or not email or not mensagem:
            flash("Por favor, preencha os campos obrigatórios (nome, email e mensagem).")
            return redirect(url_for("contato"))

        salvar_mensagem(nome, email, assunto, mensagem)
        flash("Mensagem enviada com sucesso! Retornaremos em breve.")
        return redirect(url_for("contato"))

    return render_template("contato.html", empresa=EMPRESA)

@app.route("/faq/")
def faq():
    return render_template("faq.html", faq=FAQ)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
