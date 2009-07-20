use strict;
use warnings;

use Test::More tests => 3;

use lib 't/lib';

use TestDB;

use Article;
use Category;

my $dbh = TestDB->dbh;

my @articles;
my @categories;

Category->new(title => 'bar')->create(
    $dbh => sub {
        my ($dbh, $category) = @_;

        push @categories, $category;
    }
);

Article->new(title => 'foo', category_id => $categories[0]->column('id'))
  ->create(
    $dbh => sub {
        my ($dbh, $article) = @_;

        push @articles, $article;

        $article->update_related(
            $dbh => 'category' => {set => {title => 'foo'}} =>
              sub { ok($_[1]) });
    }
  );

Article->new(id => $articles[0]->column('id'))->load(
    $dbh => {with => 'category'} => sub {
        my ($dbh, $article) = @_;

        my $category = $article->related('category');
        ok($category);
        is($category->column('title'), 'foo');
    }
);

$articles[0]->delete($dbh => sub { });
$categories[0]->delete($dbh => sub { });
